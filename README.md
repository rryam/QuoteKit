<p align="center">
  <img src= "https://github.com/rudrankriyam/RRQuotableKit/blob/main/RRQuotableKit_Logo.png" />
</p>

# RRQuotableKit

![GitHub branch checks state](https://img.shields.io/github/checks-status/rudrankriyam/RRQuotableKit/main)
![Twitter Follow](https://img.shields.io/twitter/follow/rudrankriyam?style=social)

The RRQuotableKit is a Swift framework to use the free APIs provided by [Quotable](https://github.com/lukePeavey/quotable) created by [Luke Peavey](https://github.com/lukePeavey). It uses the latest async/await syntax for easy access and contains all the APIs like fetching a random quote, all quotes, authors, tags and searching quotes and authors.

> Note: This framework is still in beta. 

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Random Quote](#random-quote)
  - [List Quotes](#list-quotes)
  - [Quote By ID](#quote-by-id)
  - [List Authors](#list-authors)
  - [Author By ID](#author-by-id)
  - [Author Profile Image URL](#author-profile-image-url)
  - [List Tags](#list-tags)
  - [Search Quotes](#search-quotes)
  - [Search Authors](#search-authors)

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

## Random Quote

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

## List Quotes 

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

## Quote By ID 

If there is one, return a single `Quote` object for the given id from the `/quotes/:id` API.

```swift 
var quote: Quote?
quote = try await RRQuotableKit.quote(id: "2xpHvSOQMD")
```

## List Authors
 
 Returns the `Authors` object matching the given queries from the `/authors` API. By default, the list contains 20 `Author` in one page. You can filter multiple authors by providing their slugs in the query parameter.
 
 ```swift 
var authors: Authors?
authors = try await RRQuotableKit.authors()
```

Few examples:

Get the first page of authors, with 20 results per page -

```swift 
try await RRQuotableKit.authors(page: 1)
```

Get the second page of authors, with 20 results per page, with a limit of 10 authors -

```swift 
try await RRQuotableKit.authors(limit: 10, page: 2)
```

Get all authors, sorted alphabetically by name -

```swift 
try await RRQuotableKit.authors(sortBy: .name)
```

Get all authors, sorted by number of quotes in descending order -

```swift 
try await RRQuotableKit.authors(sortBy: .quoteCount, order: .descending)
```

Get a single author by slug -

```swift 
try await RRQuotableKit.authors(slugs: ["albert-einstein"])
```

Get multiple authors by slug -

```swift 
try await RRQuotableKit.authors(slugs: ["albert-einstein", "abraham-lincoln"])
```

## Author By ID 

If there is one, return a single `Author` object for the given id from the `/authors/:id` API.

```swift 
var author: Author?
author = try await RRQuotableKit.author(id: "XYxYtSeixS-o")
```

## Author Profile Image URL

Returns the image URL for given author slug. You can specify the image size as well. The default image size is 700x700. 

```swift 
var authorImageURL: URL?
authorImageURL = RRQuotableKit.authorProfile(size: 1000, slug: "aesop")
```

## List Tags 

Returns the `Tags` object containing the list of all tags from the `/tags` API. You can sort it and order the sorted results.

```swift 
var tags: Tags?
tags = try await RRQuotableKit.tags()
```

Get all tags, sorted alphabetically by name -

```swift 
try await RRQuotableKit.tags(sortBy: .name)
```

Get all tags, sorted by number of quotes in descending order -

```swift 
try await RRQuotableKit.tags(sortBy: .quoteCount, order: .descending)
```

## Search Quotes 

Returns the `Quotes` object based on the search query from the `/search/quotes` API. By default, the list contains 20 `Quote` in one page.

```swift 
var quotes: Quotes?
quotes = try await RRQuotableKit.searchQuotes(for: "love")
```

Get the first page of searched quotes, with 20 results per page -

```swift 
try await RRQuotableKit.searchQuotes(for: "love", page: 1)
```

Get the second page of searched quotes, with 20 results per page, with a limit of 10 quotes -

```swift 
try await RRQuotableKit.searchQuotes(for: "love", limit: 10, page: 2)
```

## Search Authors 

Returns the `Authors` object based on the search query from the `/search/authors` API. By default, the list contains 20 `Author` in one page.

```swift 
var quotes: Quotes?
quotes = try await RRQuotableKit.searchAuthors(for: "kalam")
```

Get the first page of searched authors, with 20 results per page -

```swift 
try await RRQuotableKit.searchAuthors(for: "kalam", page: 1)
```

Get the second page of searched authors, with 20 results per page, with a limit of 10 authors -

```swift 
try await RRQuotableKit.searchAuthors(for: "kalam", limit: 10, page: 2)
```

More documentation about the data models coming soon!
