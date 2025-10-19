# Synergym Architecture

## System Overview

```mermaid
graph TB
    A[User] --> B[Web Interface]
    B --> C[Rails Application]
    C --> D[PostgreSQL Database]
    C --> E[Redis Cache]
    C --> F[Sidekiq Background Jobs]
```

## User Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant Web
    participant Rails
    participant DB
    
    User->>Web: Visit /users/sign_up
    Web->>Rails: GET /users/sign_up
    Rails->>Web: Render sign up form
    Web->>User: Display form
    User->>Web: Submit registration
    Web->>Rails: POST /users
    Rails->>DB: Create user record
    DB->>Rails: Return user
    Rails->>Web: Redirect to sign in
    Web->>User: Display sign in form
```

## Role-based Authorization

```mermaid
graph LR
    A[Guest] --> B[Sign Up]
    B --> C[Athlete]
    C --> D[Sign In]
    D --> E[Trainer]
    D --> F[Admin]
    F --> G[Full Access]
    E --> H[Limited Access]
    C --> I[Basic Access]
```

## Deployment Architecture

```mermaid
graph TB
    subgraph "Heroku"
        A[Web Dyno] --> B[Worker Dyno]
        A --> C[PostgreSQL Addon]
        B --> D[Redis Addon]
    end
    
    E[Custom Domain] --> A
    F[GitHub] --> G[Heroku Git]
    G --> A