# Synergym API Documentation

## Authentication Endpoints

### Sign Up
```mermaid
sequenceDiagram
    participant Client
    participant API
    
    Client->>API: POST /users
    API->>Client: User created or errors
```

### Sign In
```mermaid
sequenceDiagram
    participant Client
    participant API
    
    Client->>API: POST /users/sign_in
    API->>Client: Authentication token or errors
```

### Sign Out
```mermaid
sequenceDiagram
    participant Client
    participant API
    
    Client->>API: DELETE /users/sign_out
    API->>Client: Sign out confirmation
```

## User Roles

```mermaid
graph TD
    A[Admin] --> B[Full CRUD on Users]
    A --> C[Access to All Resources]
    D[Trainer] --> E[Limited User Management]
    D --> F[Training Resources]
    G[Athlete] --> H[Own Profile Only]
    G --> I[Basic Resources]