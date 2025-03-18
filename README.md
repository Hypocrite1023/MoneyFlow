## 2025.2.23 - Combine 的 .sink 與 .assign 差異

在 Combine 中，`.sink` 和 `.assign` 都是用來訂閱 publisher 的方法，但它們有一些主要差異：

### `.sink`
- 透過 closure 接收 publisher 發出的值和完成事件。
- 可以在 closure 中執行任何自訂邏輯，對接收到的值做更細緻的處理。

### `.assign`
- 將 publisher 發出的值直接分配給某個物件的屬性。
- 適用於簡單的狀態更新，不需要額外的邏輯處理。

---

## 2025.2.24 - TableView 的 didSelectRowAt 需長按 3 秒才觸發的問題

在 `AccountingPage` 中的 `TableView`，當點擊 cell 時，發現需要長按 3 秒左右才會觸發 `func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)` 方法。

### 問題原因
在 view 中加入了一個 `UITapGestureRecognizer`，導致 TableView 的點擊事件受到影響。

### 解決方案
在加入該手勢時，設定 `cancelsTouchesInView = false`，這樣可以避免手勢影響到其他視圖的點擊事件，例如 TableView 的 `didSelectRowAt` 方法。

```swift
let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
tapGesture.cancelsTouchesInView = false
view.addGestureRecognizer(tapGesture)
```

---

## 2025.2.25

我TransactionDetailView會在使用者每更改一次FilterPanel上的選項，就重新fetch一次Core Data裡的資料，使用combine的程式如下
```swift
func bindViewModelToView() {
    contentView.dateRangeSelector.$selectedIndex
        .map {
            $0!
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.viewModel.dateRangeSelected = value
            self?.viewModel.generateFilterPredicate()
        }
        .store(in: &bindings)
    contentView.typeSelector.$selectedIndex
        .map{ Array($0) }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.viewModel.transactionTypeSelected = value
            self?.viewModel.generateFilterPredicate()
        }
        .store(in: &bindings)
    contentView.categorySelector.$selectedIndex
        .map{ Array($0) }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.viewModel.categorySelected =
            value.compactMap({ index in
                self?.contentView.categorySelector.buttonList[index].title(for: .normal)
            })
            self?.viewModel.generateFilterPredicate()
        }
        .store(in: &bindings)
    contentView.paymentMethodSelector.$selectedIndex
        .map{ Array($0) }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            
            self?.viewModel.paymentMethodSelected =
            value.compactMap({ index in
                return self?.contentView.paymentMethodSelector.buttonList[index].title(for: .normal)
            })
            self?.viewModel.generateFilterPredicate()
        }
        .store(in: &bindings)
    contentView.tagSelector.$selectedIndex
        .map{ Array($0) }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            
            self?.viewModel.tagSelected =
            value.compactMap({ index in
                return self?.contentView.tagSelector.buttonList[index].title(for: .normal)
            })
            self?.viewModel.generateFilterPredicate()
        }
        .store(in: &bindings)
}
```
可是這樣在第一次畫面載入的時候，會連續fetch 5次資料，而且使用者根本還沒更新filter的選項，這時候就可以使用 `.dropFirst()`來忽略初始值
```swift
contentView.dateRangeSelector.$selectedIndex
    .dropFirst()
    .map {
        $0!
    }
    .receive(on: DispatchQueue.main)
    .sink { [weak self] value in
        self?.viewModel.dateRangeSelected = value
        self?.viewModel.generateFilterPredicate()
    }
    .store(in: &bindings)
```

---

## 2025.2.27

`Diffable data source detected item identifiers that are equal but have different hash values. Two identifiers which compare as equal must return the same hash value. You must fix this in the Hashable (Swift) or hash property (Objective-C) implementation for the type of these identifiers.`
### identifier 相同 但 hash value 不同，違反 Hashable，因為我在tableView在判斷資料是否相同是用 Core Data 每筆資料的 `NSManagedObjectID`，但我沒有額外寫hashValue的計算方式，所以他用預設的所有屬性去計算
```swift
struct Transaction: Hashable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id: NSManagedObjectID?
    var date: Date
    var type: String
    var itemName: String
    var amount: Double
    var category: String
    var payMethod: String
    var tags: [String]?
    var note: String?
    var relationGoal: UUID?
}
```
### 結果後來發現是 Core Data 在取出資料的時候，陣列順序的問題，像我記帳的資訊有包含 tag，他是一個陣列
```swift
 (MoneyFlow.Transaction(id: Optional(0x8d92ef8dafdf2e30 <x-coredata://8F6CE5D8-7925-41EC-B9D4-D0C05DBA932B/TransactionEntity/p37>), date: 2025-02-01 01:33:04 +0000, type: \"支出\", itemName: \"支付電影票\", amount: 7047.0, category: \"保險\", payMethod: \"現金\", tags: Optional([\"應酬\", \"午餐\"]), note: Optional(\"\"), relationGoal: nil))
 
 (MoneyFlow.Transaction(id: Optional(0x8d92ef8dafdf2e30 <x-coredata://8F6CE5D8-7925-41EC-B9D4-D0C05DBA932B/TransactionEntity/p37>), date: 2025-02-01 01:33:04 +0000, type: \"支出\", itemName: \"支付電影票\", amount: 7047.0, category: \"保險\", payMethod: \"現金\", tags: Optional([\"午餐\", \"應酬\"]), note: Optional(\"\"), relationGoal: nil))
```
這兩個資料的 id 也就是 NSManagedObjectID 是相同的，但是他們在tags這個陣列屬性上的順序是不同的，陣列順序不同也會造成原本Hashable 的 hashValue 計算出來的值會不同，所以要修改計算 hashValue 的 function，陣列都經過排序再計算
```swift
func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(date)
    hasher.combine(type)
    hasher.combine(itemName)
    hasher.combine(amount)
    hasher.combine(category)
    hasher.combine(payMethod)
    hasher.combine(tags?.sorted() ?? [])
    hasher.combine(note)
    hasher.combine(relationGoal)
}
```

---

## 2025.3.11

### 有時候 table view 中的 cell 數量很少，如果用 auto layout 給他那麼大的空間感覺很怪，要怎麼根據 cell 的數量調整 table view 的大小？
```swift View.swift
var settingTableViewHeightConstraint: NSLayoutConstraint! // 將 table view 的 height anchor 獨立出來

private func setView() {
    settingTableView.layer.cornerRadius = 10
    settingTableView.clipsToBounds = true
    settingTableView.isScrollEnabled = false // 禁止滾動，讓它依據內容調整大小
}

private func setConstraints() {
    NSLayoutConstraint.activate([
        settingTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
        
        settingTableView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -20),
        settingTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    ])
    settingTableViewHeightConstraint = settingTableView.heightAnchor.constraint(equalToConstant: 0)
    settingTableViewHeightConstraint.isActive = true
}
```
```swift ViewController.swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.updateSettingTableViewHeight()
}
/*
viewDidLayoutSubviews 會在 視圖的佈局過程完成後 被調用，這通常發生在以下情況：
    1.    視圖首次顯示時（例如 viewDidLoad 之後，佈局發生變化時）
    2.    視圖的大小發生變化時（例如旋轉設備或改變 view 的 frame）
    3.    子視圖的約束（Auto Layout）發生變化時（導致父視圖需要重新佈局）
    4.    手動調用 view.setNeedsLayout() 或 view.layoutIfNeeded()

這個方法適合用來 調整子視圖的佈局，但不適合用來初始化 UI，因為它可能被多次調用。
*/
```

---

## 2025.3.16

### Publisher
`Publisher`都有`Output`, `Failure`,    
- Output：代表 Publisher 發送的值的類型
- Failure：代表 Publisher 可能會發出的錯誤的類型，通常是 Error 類型，Failure種類有Never、Error或其他自訂錯誤(繼承自Error)
例如：
- URLSession.dataTaskPublisher(for: url) 的返回類型是 URLSession.DataTaskPublisher，其 Output 是 URLSession.DataTaskPublisher.Output（包含 data 和 response），而 Failure 是 URLError（表示網路錯誤）
- Just 是一個最簡單的 Publisher，它只有一個值，因此 Output 是你提供的值類型，而 Failure 則是 Never，表示不會發生錯誤

### PassthroughSubject
- 不會存儲任何值，僅在有訂閱者時才發送數據，新的訂閱者 不會收到先前的值
- 當 send(_:) 被調用時，所有訂閱者會同步收到該事件
- 適合用來處理 事件驅動（event-driven）的場景 -> 按鈕點擊事件|網路請求結果（成功/失敗）
### CurrentValueSubject
- 總是保存一個當前值，即使沒有訂閱者，也會存儲最後一次的數據
- 新訂閱者 會立即收到最新值，而不只是新的 send(_:) 事件
- 適用於需要持續保持狀態並能讓新訂閱者獲取當前狀態的場景 -> 表單輸入框|設定的當前模式（如深色/淺色模式）
### Future
- Future 創建後會馬上執行 closure 不論有無訂閱者
- 只會有一個 .success(value) 或 .failure(error)，然後就完成
### Just
- 只會發送一次數據並結束
- 不會發送錯誤
### Empty
- 不會發送任何值立即完成
### Deferred
- 延遲創建 Publisher，直到訂閱者請求數據
- 每次訂閱時，會創建新的 Publisher
### Combine的 Operator
- map: 數據轉換或改變數據的類型
- tryMap: 可以拋出錯誤的map
- filter: 過濾數據
- merge: 將兩個 `Publisher` 的數據合併成一個
- combineLatest: 將兩個 `Publisher` **最新的** 的數據合併成一個，任一個 Publisher 有最新的值就傳遞
- flatMap: 根據原本的 Publisher 的數據**產生新的 Publisher**展開並合併 -> 我覺得不好理解
```swift
// 1. 這個函數模擬 API 請求，每個數字對應不同的延遲時間
func fetchValue(_ num: Int) -> AnyPublisher<String, Never> {
    Just("數據-\(num)")
        .delay(for: .seconds(num), scheduler: RunLoop.main) // 延遲 `num` 秒
        .eraseToAnyPublisher()
}

// 2. 建立 PassthroughSubject
let subject = PassthroughSubject<Int, Never>()

// 3. 使用 flatMap 來轉換輸入數字為新的 Publisher
let cancellable = subject
    .flatMap { num in
        fetchValue(num) // 這裡每個數字會變成一個新的 Publisher
    }
    .sink { value in
        print("收到數據：\(value)")
    }

// 4. 發送數據
subject.send(3)  // 等待 3 秒後輸出「數據-3」
subject.send(1)  // 等待 1 秒後輸出「數據-1」
subject.send(2)  // 等待 2 秒後輸出「數據-2」
//（1 秒後）收到數據：數據-1
//（2 秒後）收到數據：數據-2
//（3 秒後）收到數據：數據-3
```
- catch: 處理錯誤並返回新的 Publisher，無法處理 throw 的錯誤
- tryCatch: 可以捕獲前面傳下來的錯誤(包含 throw )並回傳新的 Publisher
- removeDuplicates: 過濾重複的數據
- debounce: 延遲發送，用來防止多次觸發避免短時間內過多的輸出，保留最後一個值
- throttle: 限制數據流的頻率，它會控制在一定時間內最多發送一次數據(第一個 or 最後一個)
- reduce: 對一次資料流的數據做累加並輸出結果(當全部資料流累加結束才輸出)
- scan: 對一次資料流的數據做累加並輸出結果(每加一次就輸出一次)
```swift
let publisher = [1, 2, 3, 4, 5].publisher

let cancellable = publisher
    .scan(0, +) // 每次累加後發送
    .sink { print($0) }
// 輸出
// 1
// 3
// 6
// 10
// 15
```
- switchToLatest: 只接收最新的 Publisher 數據
- replaceNil: 替換nil值
- replaceEmpty: 當Publisher結束後沒有發送任何值，用來替換empty值
- replaceError: 發生錯誤時替換
- mapError: 轉換錯誤類型
- collect: 收集所有數據 或按設定的數量收集
- filter: 接收一個閉包 過濾掉為 false 的數據
- removeDuplicates: 移除同一資料留內連續重複的值
- first: 接受第一個或第一個符合條件的值
- last: 接受最後一個或最後一個符合條件的值
- dropFirst: 丟棄前n個值
- drop: 接收一個閉包 丟棄為 true 時的數據
- prefix: 只取前 n 個數據 或接收一個閉包 當為 true 時繼續接收數據
- merge: 合併多個同類型的 Publisher，當任何一個 Publisher 發送值時，這個值就會立刻被合併進去並傳遞出去
- zip: 合併多個 Publisher，Publisher 都有新值才傳遞組合
- prepend: 在資料流前插入數據
- append: 在資料流結束後加入數據
- retry: 發生錯誤時重新嘗試
- subscribe: 設定數據發送的 thread
- receive: 設定數據接收的 thread
- delay: 延遲數據發送
- timeout: 在指定時間內沒有數據就發送錯誤
- assign: 將 Publisher的數據綁到指定屬性
- sink: 訂閱數據流並執行閉包 或 訂閱且處理完成事件和數據
- store: 儲存 Cancellable，避免 memory leak

---

## 2025.3.18
### Thread 11: EXC_BAD_ACCESS (code=1, address=0x0)
除錯一段時間才發現是因為這段程式碼
```swift
class RandomGenerateTransaction {
    
    var currencies: [CurrencyInformation.Information] = [] {
        didSet {
            if !currencies.isEmpty {
                createRandomTransactionRecord() // 因為 currencies 是在 global thread 設定
                // 所以這邊 createRandomTransactionRecord() 也是在 global thread 被呼叫
            }
        }
    }
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = CurrencyApi.shared.fetchSupportedCurrencies()
            .receive(on: DispatchQueue.global()) // 指定在 global thread 接收資料流
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { value in
                let currency: CurrencyInformation = value
                self.currencies = currency.response // 導致這邊是在 global thread 執行
            }
    }
    
    func createRandomTransactionRecord() {
        for _ in 0..<3000 {
            let type = randomType()
            let transaction = Transaction(date: randomDate(), type: type, itemName: randomCombinedItemName(), amount: randomAmount(), currencyCode: randomCurrency(), category: randomCategory(type: type), payMethod: randomPaymentMethod(), tags: randomTag(), note: "", relationGoal: nil)
            let result = CoreDataManager.shared.addTransaction(transaction)
            print(result)
        }
    }
}
```
createRandomTransactionRecord() 在 global thread 被呼叫，function 內的 CoreDataManager.shared.addTransaction(transaction) 也在 global thread 被呼叫，CoreDataManager.shared.addTransaction(transaction) 是跟 Core Data 有關的資料操作
- Core Data 不一定 要求在主執行緒執行，但 NSManagedObjectContext (MOC) 必須在其所屬的執行緒存取。這是因為 Core Data 內部的物件 (NSManagedObject) 是與特定的 NSManagedObjectContext 綁定的，如果跨執行緒存取，可能會發生 非同步競爭 (Data Race) 或 崩潰
- NSManagedObjectContext 不是執行緒安全的：
    - Core Data 的 NSManagedObjectContext 不能在創建它的執行緒之外存取，否則會發生 crash 或 資料錯誤。
    - 如果 createRandomTransactionRecord() 嘗試在 背景執行緒 存取 NSManagedObjectContext，就可能導致 EXC_BAD_ACCESS
- NSManagedObject 不能跨執行緒使用：
    - NSManagedObject（例如你查詢出來的 TransactionRecord）只能在與它的 context 相同的執行緒上使用。
    - 如果你在背景執行緒中修改或讀取一個 從主執行緒 context 取得的 NSManagedObject，就可能發生 EXC_BAD_ACCESS。
所以要確保 Core Data 有關的操作是在主執行緒執行的
```swift
cancellable = CurrencyApi.shared.fetchSupportedCurrencies()
    .receive(on: DispatchQueue.main) // 指定在 main thread 接收資料流
    .sink { completion in
        switch completion {
            
        case .finished:
            break
        case .failure(_):
            break
        }
    } receiveValue: { value in
        let currency: CurrencyInformation = value
        self.currencies = currency.response // 也使這邊是在 main thread 執行
    }
```
