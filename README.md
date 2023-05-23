# Simple Configuration Repository API

This is a public API that provides a simple configuration repository for managing configuration models. The repository allows you to store and retrieve configuration data, as well as update the configuration.

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Error Handling](#error-handling)

## Introduction

The Simple Configuration Repository API offers a way to build and manage a configuration repository. It provides a `ConfigurationRepository` protocol and a set of related types and structures.

The main components of this API are:

- `ConfigurationRepository`: A protocol that defines the requirements for a configuration repository. It provides methods and properties for updating and retrieving configuration data.

- `ConfigurationModel`: A protocol that defines the requirements for a configuration model. It includes properties for versioning and identification of the model.

- `SimpleConfigurationRepository`: A namespace that contains helper types and methods for working with the configuration repository.

## Usage

To use the Simple Configuration Repository API, you need to follow these steps:

1. Implement a configuration model that conforms to the `ConfigurationModel` protocol. The model should include properties for versioning and identification.

2. Create an instance of the `SimpleConfigurationRepository.Settings` struct, providing the necessary settings for configuring the repository. These settings include a fallback configuration, local storage options, and remote storage options.

3. Use the `SimpleConfigurationRepository.build(settings:)` method to build an instance of the `ConfigurationRepository` corresponding to the provided settings.

4. Use the methods and properties provided by the `ConfigurationRepository` to manage and access the configuration data.

Here's an example of how to use the Simple Configuration Repository API:

```swift
// Define a configuration model
struct MyConfigurationModel: ConfigurationModel {
    var version: Int
    var id: Int { version }
    static var modelIdentifier: String = "MyConfiguration"
    static var modelVersion: Int = 1
    // Include other properties and methods as needed
}

// Create settings for the configuration repository
let settings = SimpleConfigurationRepository.Settings(
    fallback: MyConfigurationModel(version: 1),
    local: .fileManager,
    remote: .session(URLSession.shared, location: URL(string: "https://example.com/config.json")!)
)

// Build the configuration repository
let repository = SimpleConfigurationRepository.build(settings: settings)

// Update the configuration repository
do {
    let result = try await repository.update()
    // Handle the updated configuration result
} catch {
    // Handle the error
}

// Access the current configuration
let currentConfiguration = repository.current.model
```

## API Reference

### SimpleConfigurationRepository

This namespace provides helper types and methods for working with the configuration repository.

#### Method

- `build(settings:)`: Builds and returns a configuration repository based on the provided settings.
  - Parameters:
    - `settings`: The settings used to configure the repository.
  - Returns: An instance of `ConfigurationRepository` corresponding to the settings.

### ConfigurationRepository

This protocol defines the requirements for a configuration repository.

#### Associated Types

- `Configuration`: The type representing the configuration model.

#### Properties

- `fallback`: The fallback configuration.
- `current`: The current configuration result.

#### Method

- `update() async throws`: Updates the configuration repository.
  - Returns: The updated configuration result.

### ConfigurationModel

This protocol defines the requirements for a configuration model.

#### Properties

- `version`: Represents the version of the content within the model.

#### Static Properties

- `modelIdentifier`: Represents the identifier for the model class itself.
- `modelVersion`: Represents the version for the model contract itself.

## Error Handling

The Simple Configuration Repository API includes some predefined error types for handling errors that can occur in the datasource layer.

- `DataSourceError.missingDocumentsDirectory`: Indicates that the documents directory is missing.
- `DataSourceError.emptyCatch`: Indicates an empty catch block with an optional underlying error.

When working with the API, make sure to handle these errors appropriately to provide a robust and reliable configuration management system.

That's all you need to know to get started with the Simple Configuration Repository API. Happy configuring!
