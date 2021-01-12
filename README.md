# Plugin is not supported for APEX 18 and above
The plugin was built for APEX 4 and it is not recommended to use the plugin with current (v1.1) version.

# Pretius Client Side Validation
##### Oracle APEX dynamic action plugin
The plugin is dynamic action plugin to validate APEX items according to defined APEX item validations on browser side - without submitting the form.

## Preview
![Alt text](images/preview.gif?raw=true "Preview")

## Table of Contents
- [License](#license)
- [Demo Application](#demo-application)
- [Features at Glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Install](#install)
  - [Installation package](#installation-package)
  - [Install procedure](#install-procedure)
- [Usage guide](#usage-guide)
- [Plugin Settings](#plugin-settings)
- [Changelog](#changelog)
- [1.1](#11)
- [1.0](#10)
- [Known issues](#known-issues)
- [About Author](#about-author)
- [About Pretius](#about-pretius)
- [Free support](#free-support)
  - [Bug reporting and change requests](#bug-reporting-and-change-requests)
  - [Implementation issues](#implementation-issues)
- [Become a contributor](#become-a-contributor)
- [Comercial support](#comercial-support)


## License
MIT

## Demo Application
[http://apex.pretius.com/apex/f?p=PLUGINS:CLIENT_SIDE_VALIDATION](http://apex.pretius.com/apex/f?p=PLUGINS:CLIENT_SIDE_VALIDATION)

## Features at Glance
### Compatibility with Oracle APEX
The plugin is compatible with Oracle APEX 4.x and 5.x.

### Browser support
The plugin was tested under three major browsers: Internet Explorer 8+, Firefox, Chrome.

### Live validation for APEX Items
APEX item validations can be executed “on the fly” (eg. after leaving the textfield) and do not require pressing submit button and reloading the page.

### Integrated with standard APEX item validations 
(No JavaScript or jQuery knowledge required!) Unlike other validation plugins, the plugin does not require creating additional validations in Java Script. It is because the plugin executes APEX validations associated with APEX items. All you need to do is to create new dynamic action, choose affected items (by pointing APEX items or using jQuery selector) and create standard APEX validations.

### One dynamic action required 
Dynamic action implemented on Page 0 can handle APEX validations associated to all APEX items on all pages in your application. You are just few clicks from Oracle APEX live validation.

### Ready to use templates for validation result handling
With the plugin you can choose three predefined styles for presenting validation result. Each predefined template can be easly styled with overriding CSS styles.

### Custom JavaScript callback
The plugin supports callback function (in JavaScript) on validation outcome. If you are brave enough, you can define your own validation result handling. Moreover you can track every step of validation process with jQuery events that are available through APEX dynamic actions.

### Tracking live validation
The plugin uses jQuery events to let you track every step of validation. Define your tracker as you please with dynamic actions events.

## Roadmap
* [ ] Implementing debounce mechanism for “key release” event;
* [ ] New templates for validation result handling;
* [ ] Plugin attributes customization on application and page level;
* [ ] Handling APEX page validations (not associated with APEX items).

## Install

### Installation package
1. `src/dynamic_action_plugin_pretius_apex_client_side_validation.sql.sql` - the plugin installation files for Oracle APEX 5.1 or higher


### Install procedure
To successfully install/update the plugin follow those steps:
1. Install the plugin file `dynamic_action_plugin_pretius_apex_client_side_validation.sql.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

During plug-in installation, you will be asked to confirm default value of Global Error Template attribute. The default value of the attribute is default value of Error Template in section Error display for APEX 5 Universal Theme label template.

Please keep in mind that attributes Global Error Template and Error template should represent template Error template in application templates.

To learn more about APEX templates configuration please read official Oracle APEX docs

```Be sure you have read Live demo > Placeholders section before using the plugin.```

## Usage guide
Not yet described

## Plugin Settings
Detailed information about how to use every attribute of the plugin is presented in built-in help texts in APEX Application Builder.

## Changelog

## 1.1
### JavaScript
* fixed JS bug after apex error occurs

### PL/SQL
* fixed bug with handling apostrophe character in the input value.
* fixed bug that occurs on apex.oracle.com "ORA-01489: result of string concatenation is too long"
* fixed bug ERR_EMPTY_RESPONSE while installing the plugin on some APEX sets
* fixed PL/SQL issues (function returning boolean)
* apex 5 item validation "Restricted Characters" is supported

### Plugin attributes
* new plugin attribute "Re-validate depending fields" to execute depending validations

## 1.0
- Initial release

## Known issues
* multiple AJAX calls sequences are corrupted

## About Author
Author            | Website                                 | Github                                       | Twitter                                       | E-mail
------------------|-----------------------------------------|----------------------------------------------|-----------------------------------------------|----------------------------------------------------
Bartosz Ostrowski | [http://ostrowskibartosz.pl](https://www.ostrowskibartosz.pl) | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com, ostrowski.bartosz@gmail.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)

## Free support
Pretius provides free support for the plugins at the GitHub platform. 
We monitor raised issues, prepare fixes, and answer your questions. However, please note that we deliver the plug-ins free of charge, and therefore we will not always be able to help you immediately. 

Interested in better support? 
* [Become a contributor!](#become-a-contributor) We always prioritize the issues raised by our contributors and fix them for free.
* [Consider comercial support.](#comercial-support) Options and benefits are described in the chapter below.


### Bug reporting and change requests
Have you found a bug or have an idea of additional features that the plugin could cover? Firstly, please check the Roadmap and Known issues sections. If your case is not on the lists, please open an issue on a GitHub page following these rules:
* issue should contain login credentials to the application at apex.oracle.com where the problem is reproduced;
* issue should include steps to reproduce the case in the demo application;
* issue should contain description about its nature.

### Implementation issues
If you encounter a problem during the plug-in implementation, please check out our demo application. We do our best to describe each possible use case precisely. If you can not find a solution or your problem is different, contact us: apex-plugins@pretius.com.

## Become a contributor!
We consider our plugins as genuine open source products, and we encourage you to become a contributor. Help us improve plugins by fixing bugs and developing extra features. Comment one of the opened issues or register a new one, to let others know what you are working on. When you finish, create a new pull request. We will review your code and add the changes to the repository.

By contributing to this repository, you help to build a strong APEX community. We will prioritize any issues raised by you in this and any other plugins.

## Comercial support
We are happy to share our experience for free, but we also realize that sometimes response time, quick implementation, SLA, and instant release for the latest version are crucial. That’s why if you need extended support for our plug-ins, please contact us at apex-plugins@pretius.com.
We offer:
* enterprise-level assistance;
* support in plug-ins implementation and utilization;
* dedicated contact channel to our developers;
* SLA at the level your organization require;
* priority update to next APEX releases and features listed in the roadmap.