# ADR-002: Shadow Deployment
Staging model runs next to Production model. It logs predictions but never sends alerts.
We promote only after shadow is better. Costs 2x compute but safe.