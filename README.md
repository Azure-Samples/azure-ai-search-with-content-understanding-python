# Azure AI Search with Content Understanding Samples (Python)

Welcome! Content Understanding is an innovative solution designed to analyze and interpret diverse media types, including documents, images, audio, and video. It transforms this content into structured, organized, and searchable data. In this sample, we will demonstrate how to index your files using the rich insights extracted from the Content Understanding API, and subsequently index these files with Azure Search to enhance their searchability.


- The samples in this repository default to the latest preview API version: **(2024-12-01-preview)**.


## Samples

| File | Description |
| --- | --- |
| [search_with_visual_document.ipynb](notebooks/search_with_visual_document.ipynb) | Extract custom fields with content understanding API, and used it to index the file in Azure search |
| [search_with_video.ipynb](notebooks/search_with_video.ipynb) | Extract custom fields with content understanding API, and used it to index the file in Azure search |


## Getting started
### GitHub Codespaces
You can run this repo virtually by using GitHub Codespaces, which will open a web-based VS Code in your browser.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?skip_quickstart=true&machine=basicLinux32gb&repo=899687170&ref=main&geo=UsEast&devcontainer_path=.devcontainer%2Fdevcontainer.json)

### Local environment

1. Make sure the following tools are installed:

    * [Azure Developer CLI (azd)](https://aka.ms/install-azd)
    * [Python 3.11+](https://www.python.org/downloads/)

2. Make a new directory called `azure-ai-search-with-content-understanding-python` and clone this template into it using the `azd` CLI:

    ```shell
    azd init -t azure-ai-search-with-content-understanding-python
    ```

    You can also use git to clone the repository if you prefer.

## Configure Azure AI service resource
### (Option 1) Use `azd` commands to auto create temporal resources to run sample
1. Make sure you have permission to grant roles under subscription
1. Login Azure
    ```shell
    azd auth login
    ```
1. Setting up environment, following prompts to choose location
    ```shell
    azd up
    ```


### (Option 2) Manually create resources and set environment variables
1. Create [Azure AI Services resource](docs/create_azure_ai_service.md)
1. Go to `Access Control (IAM)` in resource, grant yourself role `Cognitive Services User`
1. Create [Azure OpenAI resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal)
1. Deploy GPT model
1. Deploy embedding model
1. Go to `Access Control (IAM)` in resource, grant yourself role `Cognitive Services OpenAI User`
1. Create [Azure Search resource](https://learn.microsoft.com/en-us/azure/search/search-create-service-portal)
1. Go to `Access Control (IAM)` in resource, grant yourself role `Search Index Data Contributor`
1. Go to `Access Control (IAM)` in resource, grant yourself role `Search Service Contributor`
1. Copy `notebooks/.env.sample` to `notebooks/.env`
1. Fill required information into .env from the resources you created

## Open a Jupyter notebook and follow the step-by-step guidance

Navigate to the `notebooks` directory and select the sample notebook you are interested in. Since Codespaces is pre-configured with the necessary environment, you can directly execute each step in the notebook.

## Notes

* **Trademarks** - This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos is subject to those third-party’s policies.

* **Data Collection** - The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkID=824704. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
