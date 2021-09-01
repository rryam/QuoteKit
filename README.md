<p align="center">
  <img src= "https://github.com/rudrankriyam/RRQuotableKit/blob/main/RRQuotableKit_Logo.png" />
</p>

# RRQuotableKit

![GitHub branch checks state](https://img.shields.io/github/checks-status/rudrankriyam/RRQuotableKit/main)
![Twitter Follow](https://img.shields.io/twitter/follow/rudrankriyam?style=social)


The RRQuotableKit is a Swift framework to use the free APIs provided by [Quotable](https://github.com/lukePeavey/quotable). It uses the latest async/await syntax for easy access and contains all the APIs like fetching a random quote, all quotes, authors, tags and searching quotes and authors.

## Requirements

As it uses the async/await feature of Swift 5.5, the platforms currently supported are iOS 15.0+, macOS 12.0+, watchOS 8.0+ and tvOS 15.0+. There's a [PR](https://github.com/apple/swift/pull/39051) merged in Swift language related to back deployment, and the framework will be updated accordingly to support the older OSes.

## Installation

To add RRQuotableKit in your project, the best way is via the Swift Package Manager. 

```
dependencies: [
    .package(url: "https://github.com/rudrankriyam/RRQuotableKit.git")
]
```

## Usage 

The `struct RRQuotableKit` contains static methods you can call for fetching the revelant data. For example, to get the list of quotes - 

```swift 
do {
    var quotes: Quotes?
    quotes = try await RRQuotableKit.quotes()
} catch {
    print(error)
}
```

The examples given below are similar to the ones in Quotable's [README.](https://github.com/lukePeavey/quotable/blob/master/README.md)

### Random Quote

Returns a single random `Quote` object from the `/random` API. 

```swift 
var randomQuote: Quote?
randomQuote = try await RRQuotableKit.randomQuote()
```

You can customise the request by adding query parameters like minimum and maximum length of the quote or the tag associated with it. You can also get a random quote by a specific author(s).

Few examples:

Random Quote with tags "technology" AND "famous-quotes" - 

```swift
try await RRQuotableKit.randomQuote(tags: [.technology, .famousQuotes], type: .all)
```

Random Quote with tags "History" OR "Civil Rights" -

```swift
try await RRQuotableKit.randomQuote(tags: [.history, .civilRights], type: .either)
```

Random Quote with a maximum length of 50 characters -

```swift
try await RRQuotableKit.randomQuote(maxLength: 150)
```

Random Quote with a length between 100 and 140 characters -

```swift
try await RRQuotableKit.randomQuote(minLength: 100, maxLength: 140)
```

Random Quote by the author "Aesop" and "Stephen Hawking" -

```swift
try await RRQuotableKit.randomQuote(authors: ["aesop", "stephen-hawking"])
```

### List Quotes 

Returns the `Quotes` object based on the given queries from the `/quotes` API. By default, the list contains 20 `Quote` in one page.

```swift 
var quotes: Quotes?
quotes = try await RRQuotableKit.quotes()
```

Few examples:

Get all quotes with a maximum length of 50 characters -

```swift
try await RRQuotableKit.quotes(maxLength: 150)
```

Get all quotes with a length between 100 and 140 characters -

```swift
try await RRQuotableKit.quotes(minLength: 100, maxLength: 140)
```

Get the first page of quotes, with 20 results per page -

```swift 
try await RRQuotableKit.quotes(page: 1)
```

Get the second page of quotes, with 20 results per page, with a limit of 10 quotes -

```swift 
try await RRQuotableKit.quotes(limit: 10, page: 2)
```

Get all quotes with the tags love OR happiness -

```swift 
try await RRQuotableKit.quotes(tags: [.love, .happiness], type: .either)
```

Get all quotes with the tags technology AND famous-quotes -

```swift 
try await RRQuotableKit.quotes(tags: [.technology, .famousQuotes], type: .all)
```

Get all quotes by author, using the author's slug -

```swift 
try await RRQuotableKit.quotes(authors: ["albert-einstein"])
```

Get all quotes sorted by author -

```swift 
try await RRQuotableKit.quotes(sortBy: .author)
```

Get all quotes sorted by content, in descending order -

```swift 
try await RRQuotableKit.quotes(sortBy: .content, order: .descending)
```
