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


