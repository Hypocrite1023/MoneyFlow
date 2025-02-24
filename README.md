## 2025.2.23
> 在 Combine 中，.sink 和 .assign 都是用來訂閱 publisher 的方法，但它們有一些主要差異：
>> •.sink
>>> 透過 closure 接收 publisher 發出的值和完成事件，你可以在 closure 中執行任何自訂邏輯。這讓你能夠對接收到的值做更細緻的處理。
>> •.assign
>>> 將publisher發出的值直接分配給某個物件的屬性。這通常用於簡單的狀態更新，不需要額外的邏輯處理。
## 2025.2.24
> 在AccountingPage 裡的 TableView 當我點擊時不知道為什麼需要到長按3秒左右 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 才會觸發
>> 結果是我在view中有加入一個UITapGestureRecognizer,他會影響到table view didSelectRow的觸發
>> 加上 那個手勢.cancelsTouchesInView = false，避免這個手勢影響到其他視圖的點擊
