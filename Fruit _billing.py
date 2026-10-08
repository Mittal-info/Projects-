# Fruit Inventory & Billing System
# Console based - uses only functions, dictionaries and lists

# stock: {"Apple": {"price": 180, "qty": 50}}
stock = {
    "Apple": {"price": 180, "qty": 50},
    "Banana": {"price": 60, "qty": 80},
    "Mango": {"price": 120, "qty": 40},
}

# each bill is a dictionary: {"no": 1, "items": [...], "total": 500}
bills = []


def add_fruit():
    name = input("Fruit name: ").strip().title()
    if name in stock:
        print("This fruit already exists. Use Update to increase its stock.")
        return
    price = float(input("Price per kg: "))
    qty = float(input("Quantity (kg): "))
    stock[name] = {"price": price, "qty": qty}
    print(name, "added.")


def view_stock():
    if len(stock) == 0:
        print("No fruits available.")
        return
    print("\n%-15s %-10s %-10s" % ("Fruit", "Price/kg", "Stock(kg)"))
    print("-" * 38)
    for name in stock:
        price = stock[name]["price"]
        qty = stock[name]["qty"]
        note = ""
        if qty < 5:
            note = "  <-- low stock"
        print("%-15s %-10s %-10s%s" % (name, price, qty, note))


def update_fruit():
    name = input("Which fruit do you want to update: ").strip().title()
    if name not in stock:
        print("Fruit not found.")
        return
    print("1. Change price")
    print("2. Add stock")
    choice = input("Choice: ")
    if choice == "1":
        stock[name]["price"] = float(input("New price: "))
        print("Price updated.")
    elif choice == "2":
        stock[name]["qty"] += float(input("How many kg to add: "))
        print("Stock updated.")
    else:
        print("Invalid choice.")


def delete_fruit():
    name = input("Which fruit do you want to delete: ").strip().title()
    if name in stock:
        del stock[name]
        print(name, "deleted.")
    else:
        print("Fruit not found.")


def create_bill():
    view_stock()
    items = []
    total = 0
    print("\nCreate a bill. Type 'done' as the fruit name to finish.")

    while True:
        name = input("\nFruit name: ").strip().title()
        if name == "Done":
            break
        if name not in stock:
            print("Fruit not found.")
            continue

        qty = float(input("Quantity (kg): "))
        if qty <= 0:
            print("Quantity must be greater than 0.")
            continue
        if qty > stock[name]["qty"]:
            print("Not enough stock. Available:", stock[name]["qty"])
            continue

        amount = qty * stock[name]["price"]
        stock[name]["qty"] -= qty          # reduce stock
        items.append({"name": name, "qty": qty, "amount": amount})
        total += amount
        print("Added:", name, qty, "kg =", amount)

    if len(items) == 0:
        print("Bill is empty, cancelled.")
        return

    bill_no = len(bills) + 1
    bills.append({"no": bill_no, "items": items, "total": total})
    print_bill(bills[-1])


def print_bill(bill):
    print("\n========== BILL No.", bill["no"], "==========")
    print("%-15s %-8s %-10s" % ("Fruit", "Qty(kg)", "Amount"))
    print("-" * 36)
    for item in bill["items"]:
        print("%-15s %-8s %-10.2f" % (item["name"], item["qty"], item["amount"]))
    print("-" * 36)
    print("TOTAL: Rs.", round(bill["total"], 2))
    print("=" * 31)


def view_bills():
    if len(bills) == 0:
        print("No bills created yet.")
        return
    for bill in bills:
        print_bill(bill)


def sales_report():
    total_sale = 0
    for bill in bills:
        total_sale += bill["total"]
    print("\nTotal bills:", len(bills))
    print("Total sale: Rs.", round(total_sale, 2))


def main():
    while True:
        print("\n===== FRUIT INVENTORY & BILLING =====")
        print("1. Add Fruit")
        print("2. View Stock")
        print("3. Update Fruit")
        print("4. Delete Fruit")
        print("5. Create Bill")
        print("6. View Bills")
        print("7. Sales Report")
        print("8. Exit")
        choice = input("Choice: ").strip()

        if choice == "1":
            add_fruit()
        elif choice == "2":
            view_stock()
        elif choice == "3":
            update_fruit()
        elif choice == "4":
            delete_fruit()
        elif choice == "5":
            create_bill()
        elif choice == "6":
            view_bills()
        elif choice == "7":
            sales_report()
        elif choice == "8":
            print("Bye!")
            break
        else:
            print("Invalid choice, please try again.")


main()