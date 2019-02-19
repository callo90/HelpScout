# HelpScout

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate HelpScout into your Xcode project using Carthage, add this to your `Cartfile`:

```ogdl
github "koombea/HelpScout" ~> 1.1
```

Run `carthage update` to build the framework and drag the built `HelpScout.framework` into your Xcode project.

## Usage

### Configuration

Add following Help Scout initialization code to your AppDelegate.

```swift
HelpScout.configure(mailboxID: <# Mailbox ID #>, token: "<# User Token #>")
```

### Users

Create a user

```swift
HelpScoutUser(id: <# String #>, firstName: <# String #>, lastName: <# String #>, email: <# String #>)

```

### Attachments

Create an attachment

```swift
HelpScoutAttachment(fileName: <# String #>, mimeType: <# String #>, data: <# Data #>)

```

### Conversations

To create a support request use HelpScout.createConversation with the required parameters:

Sending with Attachment:

```swift
HelpScout.createConversation(user: <# HelpScoutUser #>, body: <# String #>, attachment: <# HelpScoutAttachment #>, completion: <# (Result<Any?>) -> () #>)
```

Sending without Attachment:

```swift
HelpScout.createConversation(user: <# HelpScoutUser #>, body: <# String #>, completion: <# (Result<Any?>) -> () #>)
```