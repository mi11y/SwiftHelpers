# Getting Started with HTTPClient

Create an HTTPClient instance and use it to fetch data from an API Endpoint.

## Overview

HTTPClient will rely on `Alamofire` and `SwiftyJSON`, for making HTTP requests and for parsing JSON responses respectively. These two packages are easy to use.

## Understanding your API Endpoint

With an API Endpoint, there are three parts we are concerned about: the scheme, the hostname, the API path, and any URL query parameters. Take a look at this URL for the StarWars API.

```
https://swapi.py4e.com/api/people/2?foo=bar
```

The parts of the URL are brokedown in the table below. Understanding these parts will be useful when constructing the `URLComponents` needed by the `HTTPClient`.

| Component Name | URL Component |
| ----------- | ----------- |
| Scheme | `https` |
| Hostname | `swapi.py4e.com` |
| API Path | `/api/people/1` |
| Parameters | `foo=bar` |


## Creating the URL

Now that we understand the URL components, we can begin creating the URL as an instance of a `URLComponent` to be used by `HTTPClient`.

```swift
var urlComponents = URLComponents()
urlComponents.scheme   = "http"
urlComponents.host     = "swapi.py4e.com"
urlComponents.path     = "/api/people/1"
```

The query parameters will be created in the next section are not a part of the `urlComponents`.

## Creating the Query Parameters

Query parameters are composed of a Swift Dictionary `[String:String]`. In the above example URL, the key-value pairs are `foo` and `bar` respectively.

We can representing these query parameters like this:

```swift
let queryParameters = ["foo":"bar"]
```

## Creating the HTTP Client

Now we are ready to set up an instance of the `HTTPClient`. We will need to import `Alamofire` and `SwiftyJSON` packages as well. With these packages imported, we can create an instance of the client, and pass in an instance of an `Alamofire.Session` and our `urlComponents` as parameters.

```swift
import Alamofire
import SwiftyJSON

let httpClient = HTTPClient(
                     sessionManager: Alamofire.Session(),
                     serviceLocatorURL: urlComponents
                 )
```

Next, we can call the client's `setQueryParameters(_:[String:String])` method to set our query parameters on the client.

```swift
httpClient.setQueryParameters(queryParameters)
```

Then, we can define our `onSuccess` and `onFailure` closures that will handle their respective situations. In the success closure, the results of the request are already parsed by `SwiftyJSON`.

```swift
httpClient.onSuccess = { (actualResponse: JSON?) -> Void in
    debugPrint(actualResponse!)
}
httpClient.onFailure = { (_: Int?, _: String?) -> Void in
    XCTFail("Something went wrong!")
}
```

Finally, we can call the `fetch()` method on the client to perform the request. 

## Complete Code Example

Here are all the code snippets combined.

```swift
import Alamofire
import SwiftyJSON

var urlComponents = URLComponents()
urlComponents.scheme   = "http"
urlComponents.host     = "swapi.py4e.com"
urlComponents.path     = "/api/people/1"

let queryParameters = ["foo":"bar"]

let httpClient = HTTPClient(
                     sessionManager: Alamofire.Session(),
                     serviceLocatorURL: urlComponents
                 )

httpClient.setQueryParameters(queryParameters)

httpClient.onSuccess = { (actualResponse: JSON?) -> Void in
    debugPrint(actualResponse!)
}
httpClient.onFailure = { (_: Int?, _: String?) -> Void in
    XCTFail("Something went wrong!")
}

httpClient.fetch()
```

As a result, we would see the following output from the StarWarsAPI endpoint (truncated):

```
{
  ...
  "skin_color" : "fair",
  "name" : "Luke Skywalker",
  "height" : "172",
  "eye_color" : "blue",
  "gender" : "male",
  "url" : "https:\/\/swapi.py4e.com\/api\/people\/1\/",
  "birth_year" : "19BBY"
}
```

## See Also

- ``HTTPClient``
