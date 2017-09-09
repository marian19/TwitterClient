# TwitterClient

## List of design patterns:
• Model-View-Presenter (MVP )

• Delegation and Protocols

• Singleton

## Application implementation:

In each screen is implemented using the following classes and protocols:

• A contract class which defines the connection between the view and the presenter through presenter protocol and view protocol.

• A ViewController which implements the view protocol. it's responsible for displays data and reacts to user actions.

• A Presenter which implements the presenter protocol in the corresponding contract and responsible for provides View with data from local or remote dataSource .

I use MVP over MVC to avoid the issue of massive view controllers and it’s easier to test

## Diagram
![image](https://github.com/marian19/TwitterClient/blob/master/Diagram.png)
