```mermaid
graph TB
    subgraph Frontend
        A[React]
        B[Redux]
        C[Router]
        A --> B
        A --> C
    end

    subgraph Backend
        D[Node.js]
        E[Express]
        F[MongoDB]
        D --> E
        E --> F
    end

    subgraph ExternalServices
        G[Stripe]
        H[SendGrid]
    end

    Frontend --> Backend
    Backend --> ExternalServices
    Backend --> G
    Backend --> H