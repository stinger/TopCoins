# TopCoins

TopCoins is my submission on the iOS Take Home Test. 

Below are some things I would like to address:

- The application uses a mixture of `UIKit` and `SwiftUI` code, where the most of the UI is built with `UIKit` (navigation, tabs, screens) but certain small views are built with `SwiftUI` (performance graphs, some collection view cell content).

- The application uses the MVVM+C pattern, with a custom implementation of the coordinator pattern as my goal was not to use any external frameworks.

- The application uses Combine observation for most of the ViewController - ViewModel communication for backwards compatibility, but easily be updated to Swift Concurrency, if needed.

- The chosen networking stack is testable (see `APIURLTests.swift`) to the point where we can have mock response JSONs for any endpoint URL (although just some cases are mocked in the demo).

- The bookmarking is implemented using a `UserDefaults`, so the bookmarks are saved in the device. This can easily be modified to rely on an external API.

- The testing coverage of the project is above 90%. Tested are both most of the units and some of the UI interaction (searching, bookmarking)


## API secret setup

In order to properly authenticate your requests, and experience the app as intended, an access token is needed for the __Coinranking API__

To do so, please follow the steps below:

1. Generate a token
   
   To generate the API token, follow the instructions at the [Coinranking developer portal](https://developers.coinranking.com/api/documentation)

2. Set the token in an environment variable.

   For best results the environment variable should can stored in your shell `.*rc` file which gets loaded for every user session. I am using `zsh`, so i am adding the following at the end of my `.zshrc` file :

   ```sh
   COINRANKING_API_SECRET=coinranking...
   ```
3. Restart the session or reload it with the following command:

   ```sh
   source ~/.zshrc
   ```
4. Confirm that you can see your newly created variable by invoking

   ```sh
   printenv
   ```

   ## Author Info

   Ilian Konchev ([ilian@snappmobile.io](mailto:ilian@snappmobile.io))

   Software Engineer, SnappMobile Germany GmbH
