# Mock SAML IDP for Testing

This repository contains a mock SAML Identity Provider (IDP) for testing SAML authentication flows.

## Features

- SAML 2.0 compliant IdP
- Includes multiple test users with configurable attributes
- Serves SAML metadata for easy SP configuration
- Packaged for deployment on Railway.app

## Included Test Users

The IdP comes with several pre-configured test users, all with the password `password123`:

- john (john.smithshib2@uchicago.edu)
- emma (emma.johnson@uchicago.edu)
- michael (michael.williams@uchicago.edu)
- And more! See `mockidp.yaml` for the full list

## Deployment on Railway

This repository is configured for one-click deployment on Railway.app:

1. Fork this repository to your GitHub account
2. Create a new Railway project
3. Select "Deploy from GitHub repo"
4. Connect and select your forked repository
5. Click "Deploy Now"

Railway will automatically build and deploy the application. Once deployed, you'll get a URL like:
`https://mock-idp-production-xxxx.up.railway.app`

## Configuration

### Service Provider Configuration

Configure your Service Provider to use the following endpoints:

- **Metadata URL**: `https://your-railway-app-url/metadata`
- **Entity ID**: Should match the `name` in the mockidp.yaml service provider configuration
- **ACS URL**: Should match the `response_url` in the mockidp.yaml service provider configuration

### SAML Attribute Mapping

The IdP provides the following attributes:
- Email address: `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`
- First name: `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname`
- Last name: `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname`

## Local Development

To run the mock IdP locally:

```bash
docker-compose up -d
```

This will start the IdP on port 5001 and the metadata server on port 5002.

## License

This project uses the original mock-idp which is licensed under the Apache License 2.0. 