# QuoteKit


QuoteKit is a Swift framework for accessing quotes from the Quotable API. It provides a clean, async/await interface for fetching quotes, authors, and tags.

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Random Quote](#random-quote)
  - [List Quotes](#list-quotes)
  - [Quote By ID](#quote-by-id)
  - [List Authors](#list-authors)
  - [Author By ID](#author-by-id)
  - [List Tags](#list-tags)
  - [Search Quotes](#search-quotes)
  - [Search Authors](#search-authors)
- [Data Models](#data-models)

## Requirements

As it uses the async/await feature of Swift 5.5, the platforms supported are iOS 15.0+, macOS 12.0+, watchOS 8.0+, and tvOS 15.0+.

## Installation

Add QuoteKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/rudrankriyam/QuoteKit.git", .upToNextMajor(from: "2.0.0"))
]
```

## Usage

QuoteKit provides static methods for fetching data. All methods are async and throw errors on failure.

## Random Quote

Returns a single random quote:

```swift
let quote = try await QuoteKit.randomQuote()
print(quote.content)
```

You can filter by tags, length, or author:

```swift
// Quotes with specific tags
try await QuoteKit.randomQuote(tags: ["wisdom", "life"])

// Quotes within length range
try await QuoteKit.randomQuote(minLength: 50, maxLength: 150)

// Quotes by specific authors
try await QuoteKit.randomQuote(authors: ["albert-einstein"])
```

## List Quotes

Returns a paginated list of quotes. By default returns 10 quotes per page:

```swift
let quotes = try await QuoteKit.quotes()
print("Found \(quotes.count) quotes")
```

Filter and sort quotes:

```swift
// Filter by tags
try await QuoteKit.quotes(tags: ["love", "friendship"])

// Filter by length
try await QuoteKit.quotes(minLength: 50, maxLength: 150)

// Filter by author
try await QuoteKit.quotes(authors: ["mark-twain"])

// Sort by date added
try await QuoteKit.quotes(sortBy: .dateAdded, order: .descending)

// Pagination
try await QuoteKit.quotes(limit: 25, page: 2)
```

## Quote By ID

Returns a single quote by its ID:

```swift
let quote = try await QuoteKit.quote(id: "abc123")
```

## List Authors

Returns a paginated list of authors. By default returns 10 authors per page:

```swift
let authors = try await QuoteKit.authors()
```

Filter and sort authors:

```swift
// Pagination
try await QuoteKit.authors(limit: 25, page: 2)

// Sort by name
try await QuoteKit.authors(sortBy: .name)

// Sort by quote count
try await QuoteKit.authors(sortBy: .quoteCount, order: .descending)
```

## Author By ID

Returns a single author by ID:

```swift
let author = try await QuoteKit.author(id: "abc123")
```

## Author Profile Image URL

Returns the image URL for an author's profile:

```swift
let imageURL = QuoteKit.authorImage(with: "albert-einstein")
```

## List Tags

Returns all available tags:

```swift
let tags = try await QuoteKit.tags()
```

## Search Quotes

Search for quotes containing specific text:

```swift
let quotes = try await QuoteKit.searchQuotes(for: "love")
```

## Search Authors

Search for authors by name:

```swift
let authors = try await QuoteKit.searchAuthors(for: "einstein")
```

## Data Models

### Quote
Represents a single quote:

```swift
struct Quote: Decodable, Identifiable {
    let id: String
    let tags: [String]
    let content: String
    let author: String
    let authorSlug: String
    let length: Int
    let dateAdded: String
    let dateModified: String
}
```

### Author
Represents a single author:

```swift
struct Author: Decodable, Identifiable {
    let id: String
    let link: String
    let bio: String
    let description: String
    let name: String
    let quoteCount: Int
    let slug: String
    let dateAdded: String
    let dateModified: String
    let quotes: [Quote]?
}
```

### Quotes and Authors
These are collections that support pagination:

```swift
typealias Quotes = QuoteItemCollection<Quote>
typealias Authors = QuoteItemCollection<Author>
```

### Tag
Represents a quote tag:

```swift
struct Tag: Decodable, Identifiable {
    let id: String
    let name: String
    let quoteCount: Int
    let dateAdded: String
    let dateModified: String
}
```

### QuoteItemCollection
A generic paginated collection:

```swift
struct QuoteItemCollection<Item: Decodable>: Decodable {
    let count: Int
    let totalCount: Int
    let page: Int
    let totalPages: Int
    let lastItemIndex: Int?
    let results: [Item]
}
```

[![Star History Chart](https://api.star-history.com/svg?repos=rryam/QuoteKit&type=Date)](https://star-history.com/#rryam/QuoteKit&Date)
