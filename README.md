<p align="center">
  <img src= "https://github.com/rudrankriyam/QuoteKit/blob/main/QuoteKit_Logo.png" alt="QuoteKit Logo" width="256"/>
</p>

# QuoteKit

![Twitter Follow](https://img.shields.io/twitter/follow/rudrankriyam?style=social)

The QuoteKit is a Swift framework to use the free APIs provided by [Quotable](https://github.com/lukePeavey/quotable) created by [Luke Peavey](https://github.com/lukePeavey). It uses the latest async/await syntax for easy access and contains all the APIs like fetching a random quote, all quotes, authors, tags and searching quotes and authors.

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
- [Data Models](#data-models)

## Requirements

As it uses the async/await feature of Swift 5.5, the platforms currently supported are iOS 15.0+, macOS 12.0+, watchOS 8.0+ and tvOS 15.0+. There's a [PR](https://github.com/apple/swift/pull/39051) merged in Swift language related to back deployment, and the framework will be updated accordingly to support the older OSes.

## Installation

To add QuoteKit in your project, the best way is via the Swift Package Manager. 

```
dependencies: [
    .package(url: "https://github.com/rudrankriyam/QuoteKit.git")
]
```

## Usage 

The `struct QuoteKit` contains static methods you can call for fetching the revelant data. For example, to get the list of quotes - 

```swift 
do {
    var quotes: Quotes?
    quotes = try await QuoteKit.quotes()
} catch {
    print(error)
}
```

The examples given below are similar to the ones in Quotable's [README.](https://github.com/lukePeavey/quotable/blob/master/README.md)

## Random Quote

Returns a single random `Quote` object from the `/random` API. 

```swift 
var randomQuote: Quote?
randomQuote = try await QuoteKit.randomQuote()
```

You can customise the request by adding query parameters like minimum and maximum length of the quote or the tag associated with it. You can also get a random quote by a specific author(s).

Few examples:

Random Quote with tags "technology" AND "famous-quotes" - 

```swift
try await QuoteKit.randomQuote(tags: [.technology, .famousQuotes], type: .all)
```

Random Quote with tags "History" OR "Civil Rights" -

```swift
try await QuoteKit.randomQuote(tags: [.history, .civilRights], type: .either)
```

Random Quote with a maximum length of 50 characters -

```swift
try await QuoteKit.randomQuote(maxLength: 150)
```

Random Quote with a length between 100 and 140 characters -

```swift
try await QuoteKit.randomQuote(minLength: 100, maxLength: 140)
```

Random Quote by the author "Aesop" and "Stephen Hawking" -

```swift
try await QuoteKit.randomQuote(authors: ["aesop", "stephen-hawking"])
```

## List Quotes 

Returns the `Quotes` object based on the given queries from the `/quotes` API. By default, the list contains 20 `Quote` in one page.

```swift 
var quotes: Quotes?
quotes = try await QuoteKit.quotes()
```

Few examples:

Get all quotes with a maximum length of 50 characters -

```swift
try await QuoteKit.quotes(maxLength: 150)
```

Get all quotes with a length between 100 and 140 characters -

```swift
try await QuoteKit.quotes(minLength: 100, maxLength: 140)
```

Get the first page of quotes, with 20 results per page -

```swift 
try await QuoteKit.quotes(page: 1)
```

Get the second page of quotes, with 20 results per page, with a limit of 10 quotes -

```swift 
try await QuoteKit.quotes(limit: 10, page: 2)
```

Get all quotes with the tags love OR happiness -

```swift 
try await QuoteKit.quotes(tags: [.love, .happiness], type: .either)
```

Get all quotes with the tags technology AND famous-quotes -

```swift 
try await QuoteKit.quotes(tags: [.technology, .famousQuotes], type: .all)
```

Get all quotes by author, using the author's slug -

```swift 
try await QuoteKit.quotes(authors: ["albert-einstein"])
```

Get all quotes sorted by author -

```swift 
try await QuoteKit.quotes(sortBy: .author)
```

Get all quotes sorted by content, in descending order -

```swift 
try await QuoteKit.quotes(sortBy: .content, order: .descending)
```

## Quote By ID 

If there is one, return a single `Quote` object for the given id from the `/quotes/:id` API.

```swift 
var quote: Quote?
quote = try await QuoteKit.quote(id: "2xpHvSOQMD")
```

## List Authors
 
 Returns the `Authors` object matching the given queries from the `/authors` API. By default, the list contains 20 `Author` in one page. You can filter multiple authors by providing their slugs in the query parameter.
 
 ```swift 
var authors: Authors?
authors = try await QuoteKit.authors()
```

Few examples:

Get the first page of authors, with 20 results per page -

```swift 
try await QuoteKit.authors(page: 1)
```

Get the second page of authors, with 20 results per page, with a limit of 10 authors -

```swift 
try await QuoteKit.authors(limit: 10, page: 2)
```

Get all authors, sorted alphabetically by name -

```swift 
try await QuoteKit.authors(sortBy: .name)
```

Get all authors, sorted by number of quotes in descending order -

```swift 
try await QuoteKit.authors(sortBy: .quoteCount, order: .descending)
```

Get a single author by slug -

```swift 
try await QuoteKit.authors(slugs: ["albert-einstein"])
```

Get multiple authors by slug -

```swift 
try await QuoteKit.authors(slugs: ["albert-einstein", "abraham-lincoln"])
```

## Author By ID 

If there is one, return a single `Author` object for the given id from the `/authors/:id` API.

```swift 
var author: Author?
author = try await QuoteKit.author(id: "XYxYtSeixS-o")
```

## Author Profile Image URL

Returns the image URL for given author slug. You can specify the image size as well. The default image size is 700x700. 

```swift 
var authorImageURL: URL?
authorImageURL = QuoteKit.authorProfile(size: 1000, slug: "aesop")
```

## List Tags 

Returns the `Tags` object containing the list of all tags from the `/tags` API. You can sort it and order the sorted results.

```swift 
var tags: Tags?
tags = try await QuoteKit.tags()
```

Get all tags, sorted alphabetically by name -

```swift 
try await QuoteKit.tags(sortBy: .name)
```

Get all tags, sorted by number of quotes in descending order -

```swift 
try await QuoteKit.tags(sortBy: .quoteCount, order: .descending)
```

## Search Quotes 

Returns the `Quotes` object based on the search query from the `/search/quotes` API. By default, the list contains 20 `Quote` in one page.

```swift 
var quotes: Quotes?
quotes = try await QuoteKit.searchQuotes(for: "love")
```

Get the first page of searched quotes, with 20 results per page -

```swift 
try await QuoteKit.searchQuotes(for: "love", page: 1)
```

Get the second page of searched quotes, with 20 results per page, with a limit of 10 quotes -

```swift 
try await QuoteKit.searchQuotes(for: "love", limit: 10, page: 2)
```

## Search Authors 

Returns the `Authors` object based on the search query from the `/search/authors` API. By default, the list contains 20 `Author` in one page.

```swift 
var quotes: Quotes?
quotes = try await QuoteKit.searchAuthors(for: "kalam")
```

Get the first page of searched authors, with 20 results per page -

```swift 
try await QuoteKit.searchAuthors(for: "kalam", page: 1)
```

Get the second page of searched authors, with 20 results per page, with a limit of 10 authors -

```swift 
try await QuoteKit.searchAuthors(for: "kalam", limit: 10, page: 2)
```

## Data Models 

There are many different data models for using this framework. 

- `Quote`

The object represents a single quote. You can get the content of the quote using the `content` variable. The `tags` is an array of the relevant tag associated with the quote. To get the number of characters in the quote, use `length.`

```swift 
struct Quote: Decodable, Identifiable {
    var id: String
    var tags: [String]
    var content: String
    var author: String
    var authorSlug: String
    var length: Int
    var dateAdded: String
    var dateModified: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags, content, author, authorSlug, length, dateAdded, dateModified
    }
}
```

- `Author`

The object represents a single author. You can get the link to their Wikipedia page or their official website using `link.` `bio` contains a brief, one paragraph about the author. Use `description` instead to get a shorter description of the person's occupation or what they're known for. `quotes` contains an array of the author's quote.

```swift
struct Author: Decodable, Identifiable {
    var id: String
    var link: String
    var bio: String
    var description: String
    var name: String
    var quoteCount: Int
    var slug: String
    var dateAdded: String
    var dateModified: String
    var quotes: [Quote]?
    
    enum CodingKeys: String, CodingKey {
        case link, bio, description
        case id = "_id"
        case name, quoteCount, slug
        case dateAdded, dateModified
        case quotes
    }
}

extension Author: Equatable {
    static func ==(lhs: Author, rhs: Author) -> Bool {
        lhs.id == rhs.id
    }
}
```
