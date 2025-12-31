Salesforce Metadata Search LWC
A powerful Lightning Web Component for unified, cross-metadata search in Salesforce. Instantly find, filter, and access Apex, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more—all from a single interface.

<img src="https://img.shields.io/badge/Salesforce API-v64.0-blue" alt="Salesforce API">

<img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">

📋 Overview
Salesforce Metadata Search LWC is designed to solve a key Salesforce admin and developer pain point: searching and navigating metadata. Instead of clicking through multiple setup pages, this app provides a single, modern UI to search, filter, and directly access all major metadata types.

✨ Features
🔍 Unified Metadata Search – Search across Apex Classes, Triggers, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more.
🗂️ Type Filtering – Instantly filter results by metadata type.
🔗 Direct Navigation – One-click links to setup or record detail pages.
📑 Dynamic Table – Displays API Version or Folder for relevant types.
⚡ Fast & Responsive – Built as a Lightning Web Component for optimal performance.
🛡️ Security Compliant – Respects user permissions and sharing.
🧩 Extensible – Easily add support for more metadata types.
🚀 Getting Started
Prerequisites
Salesforce org with Lightning Experience enabled
System Administrator or equivalent permissions for deployment
Installation
Clone or download this repository.
Deploy the contents of the default directory to your Salesforce org using Salesforce CLI or VS Code Salesforce Extensions.
Assign the component to a Lightning App Page, Home Page, or Utility Bar as needed.
Usage
Open the Metadata Search app/component in your org.
Enter a search term and/or select a metadata type.
View results in the table, with direct links to each metadata record.
For Reports, Dashboards, and Email Templates, the Folder column is shown; for other types, API Version is displayed.
🛠️ Project Structure
🧪 Testing
Apex test coverage is provided via META_MetadataSearchControllerTest.cls.
LWC can be tested in any Lightning App Page or Utility Bar context.
🤝 Contributing
Contributions are welcome! Please:

Fork the repository

Salesforce Metadata Search LWC
A powerful Lightning Web Component for unified, cross-metadata search in Salesforce. Instantly find, filter, and access Apex, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more—all from a single interface.

<img src="https://img.shields.io/badge/Salesforce API-v64.0-blue" alt="Salesforce API">

<img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">

📋 Overview
Salesforce Metadata Search LWC is designed to solve a key Salesforce admin and developer pain point: searching and navigating metadata. Instead of clicking through multiple setup pages, this app provides a single, modern UI to search, filter, and directly access all major metadata types.

✨ Features
🔍 Unified Metadata Search – Search across Apex Classes, Triggers, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more.
🗂️ Type Filtering – Instantly filter results by metadata type.
🔗 Direct Navigation – One-click links to setup or record detail pages.
📑 Dynamic Table – Displays API Version or Folder for relevant types.
⚡ Fast & Responsive – Built as a Lightning Web Component for optimal performance.
🛡️ Security Compliant – Respects user permissions and sharing.
🧩 Extensible – Easily add support for more metadata types.

🚀 Getting Started

**Prerequisites**
- Salesforce org with Lightning Experience enabled
- System Administrator or equivalent permissions for deployment

**Installation**
1. Clone or download this repository.
2. Deploy the contents of the default directory to your Salesforce org using Salesforce CLI or VS Code Salesforce Extensions.
3. Assign the component to a Lightning App Page, Home Page, or Utility Bar as needed.

**Usage**
1. Open the Metadata Search app/component in your org.
2. Enter a search term and/or select a metadata type.
3. View results in the table, with direct links to each metadata record.
4. For Reports, Dashboards, and Email Templates, the Folder column is shown; for other types, API Version is displayed.

🛠️ Project Structure

force-app/
└── main/
	└── default/
		├── classes/
		│   ├── META_MetadataSearchController.cls
		│   └── META_MetadataSearchControllerTest.cls
		└── lwc/
			└── metaMetadataSearch/
				├── metaMetadataSearch.html
				├── metaMetadataSearch.js
				├── metaMetadataSearch.js-meta.xml
				└── metaMetadataSearch.css

🧪 Testing
- Apex test coverage is provided via META_MetadataSearchControllerTest.cls.
- LWC can be tested in any Lightning App Page or Utility Bar context.

🤝 Contributing
Contributions are welcome! Please:
- Fork the repository
- Create a feature branch
- Submit a pull request with a clear description

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

👤 Author
Abhishek Sharma

GitHub: @cloudwithabhi
Email: contact@cloudwithabhi.com
Organization: CloudWithAbhi

🙏 Acknowledgments
- Salesforce Developer Community
- All contributors and testers
- Made with ❤️ by Abhishek Sharma | Powered by Salesforce