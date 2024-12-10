#!/bin/bash

# Clear the contents of the .env file
> notebooks/.env

# Append new values to the .env file
echo "AZURE_AI_SERVICE_ENDPOINT=$(azd env get-value AZURE_AI_SERVICE_ENDPOINT)" >> notebooks/.env
echo "AZURE_OPENAI_ENDPOINT=$(azd env get-value AZURE_OPENAI_ENDPOINT)" >> notebooks/.env
echo "AZURE_OPENAI_CHAT_DEPLOYMENT_NAME=$(azd env get-value AZURE_OPENAI_CHAT_DEPLOYMENT_NAME)" >> notebooks/.env
echo "AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME=$(azd env get-value AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME)" >> notebooks/.env
echo "AZURE_SEARCH_ENDPOINT=$(azd env get-value AZURE_SEARCH_ENDPOINT)" >> notebooks/.env
