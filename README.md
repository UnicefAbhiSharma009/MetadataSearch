# Salesforce Metadata Search LWC

A powerful Lightning Web Component for unified, cross-metadata search in Salesforce. Instantly find, filter, and access Apex, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more—all from a single interface.

![Salesforce API](https://img.shields.io/badge/Salesforce%20API-v64.0-blue)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

---

## Overview

Salesforce Metadata Search LWC streamlines the process of searching and navigating Salesforce metadata. With a modern UI, it enables admins and developers to quickly locate and access all major metadata types from one place.

---

## Features

- **Unified Search:** Search across Apex Classes, Triggers, Permission Sets, Reports, Dashboards, Email Templates, Objects, Fields, and more.
- **Type Filtering:** Instantly filter results by metadata type.
- **Direct Navigation:** One-click links to setup or record detail pages.
- **Dynamic Table:** Displays API Version or Folder for relevant types.
- **Performance:** Fast and responsive Lightning Web Component.
- **Security:** Respects user permissions and sharing.
- **Extensible:** Easily add support for more metadata types.

---

## Getting Started

### Prerequisites

- Salesforce org with Lightning Experience enabled
- System Administrator or equivalent permissions

### Installation

1. Clone or download this repository.
2. Deploy the contents of the `default` directory to your Salesforce org using Salesforce CLI or VS Code Salesforce Extensions.
3. Assign the component to a Lightning App Page, Home Page, or Utility Bar.

### Usage

1. Open the Metadata Search app/component in your org.
2. Enter a search term and/or select a metadata type.
3. View results in the table, with direct links to each metadata record.
4. For Reports, Dashboards, and Email Templates, the Folder column is shown; for other types, API Version is displayed.

---

## Project Structure

```
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
```

---

## Testing

- Apex test coverage is provided via `META_MetadataSearchControllerTest.cls`.
- LWC can be tested in any Lightning App Page or Utility Bar context.

---

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request with a clear description.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author

**Abhishek Sharma**  
GitHub: [@cloudwithabhi](https://github.com/cloudwithabhi)  
Email: contact@cloudwithabhi.com  
Organization: CloudWithAbhi

---

## Acknowledgments

- Salesforce Developer Community
- All contributors and testers
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