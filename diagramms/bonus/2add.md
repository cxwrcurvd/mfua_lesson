```mermaid
classDiagram
    class User {
        +String name
        +String email
        +String address
        +placeOrder()
        +trackOrder()
    }
    
    class Restaurant {
        +String name
        +String cuisine
        +Menu menu
        +acceptOrder()
        +updateStatus()
    }
    
    class Order {
        +String orderId
        +List~OrderItem~ items
        +String status
        +calculateTotal()
        +updateStatus()
    }
    
    class Courier {
        +String name
        +String vehicle
        +acceptDelivery()
        +updateLocation()
    }
    
    User "1" -- "*" Order
    Restaurant "1" -- "*" Order
    Order "1" -- "1" Courier