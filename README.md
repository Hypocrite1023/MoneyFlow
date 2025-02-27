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

