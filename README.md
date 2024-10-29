<img width="632" alt="image" src="https://github.com/user-attachments/assets/b9159662-4577-497d-aa09-115bbe3c9e96">


# Porsche Configuration App Backend
A serverless backend system for Porsche vehicle customization and visualization service.

## Architecture Overview
This project is built on a serverless architecture, leveraging various AWS services:

* API Gateway: Provides HTTP API endpoints
* Lambda: Handles business logic
* DynamoDB: Stores user and vehicle configuration data
* DALL-E API: Generates customized vehicle images

## Tech Stack

- Infrastructure as Code: Terraform
- Runtime: Python 3.9
- API Documentation: OpenAPI (Swagger)

## Getting Started
### Prerequisites

- AWS CLI installed and configured
- Terraform installed
- DALL-E API key

### Environment Setup

1. Configure AWS Credentials:

```bash
aws configure
```

2. Set Environment Variables:

```bash
export AWS_REGION=eu-central-1
```

3. Create terraform.tfvars file:

```hcl
dalle_api_key = "your-api-key-here"
Deployment
```
```bash
# Initialize Terraform
terraform init

# Deploy
terraform apply
```

## API Endpoints
Base URL: https://[api-gateway-url]/

### Create User
```http
POST /users
Content-Type: application/json

{
  "userId": "string",
  "name": "string",
  "age": number,
  "gender": "string",
  "colorBlindness": boolean,
  "carConfiguration": {
    "model": "string",
    "color": "string",
    "tire": "string",
    "interior": "string",
    "additionalFeatures": object
  }
}
```

### Get User Information
```http
GET /users/{userId}
```

## Mobile App Integration Guide
### API Integration

1. Set API Base URL:

```javascript
const API_BASE_URL = 'https://[api-gateway-url]';
```

2. API Call Examples:

```javascript
// Create user
const createUser = async (userData) => {
  const response = await fetch(`${API_BASE_URL}/users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  });
  return response.json();
};

// Get user information
const getUser = async (userId) => {
  const response = await fetch(`${API_BASE_URL}/users/${userId}`);
  return response.json();
};
```
### Error Handling
The API returns the following HTTP status codes:

- 200: Success
- 400: Bad Request
- 404: Resource Not Found
- 500: Server Error

## Infrastructure Management
### Modifying Resources

1. Update Terraform configuration files:

- main.tf: Main resource definitions
- variables.tf: Variable definitions
- outputs.tf: Output definitions


2. Apply changes:

```bash
terraform plan  # Preview changes
terraform apply # Apply changes
```

### Resource Cleanup
```bash
terraform destroy
```

## Monitoring

- View Lambda function logs through CloudWatch
- Monitor API calls via API Gateway dashboard
- Check data in DynamoDB console

## Cost Management
AWS services are billed based on usage:

- API Gateway: Per API call
- Lambda: Based on execution time and memory usage
- DynamoDB: Based on read/write capacity and storage

## Security

- IAM roles and policies for permission management
- CORS configuration in API Gateway
- Secure key management through environment variables




