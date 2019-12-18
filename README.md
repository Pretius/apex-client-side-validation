# Plugin is not supported for APEX 18 and above
The plugin was built for APEX 4 and it is not recommended to use the plugin with current (v1.1) version.

# Pretius Client Side Validation
##### Oracle APEX dynamic action plugin
The plugin is dynamic action plugin to validate APEX items according to defined APEX item validations on browser side - without submitting the form.

## Preview
![Alt text](/preview.gif?raw=true "Preview")

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
- [Support](#support)
  - [Free support](#free-support)
  - [Paid support](#paid-support)


## License
MIT

## Demo Application
[http://apex.pretius.com/apex/f?p=PLUGINS:CLIENT_SIDE_VALIDATION](http://apex.pretius.com/apex/f?p=PLUGINS:CLIENT_SIDE_VALIDATION)

## Features at Glance
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
1. `src/TBD.sql` - the plugin installation files for Oracle APEX 5.1 or higher


### Install procedure
To successfully install/update the plugin follow those steps:
1. Install the plugin file `TBD.sql` using Oracle APEX plugin import wizard
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
* TBD

## About Author
Author            | Website                                 | Github                                       | Twitter                                       | E-mail
------------------|-----------------------------------------|----------------------------------------------|-----------------------------------------------|----------------------------------------------------
Bartosz Ostrowski | [http://ostrowskibartosz.pl](https://www.ostrowskibartosz.pl) | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com, ostrowski.bartosz@gmail.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)

## Support
Our plugins are free to use but in some cases you might need to contact us. We are willing to assist you but in certain circumstances you will be charged for our time spent on helping you. Please keep in mind we do our best to keep documentation up to date and we won't answer question for which there is explaination in documentation (at github and as help text in application builder).

All request (bug fix / change request) should be posted in Issues Tab at github repository.

### Free support
We do support the plugin in certain cases such as bug fixing and change request. If you have faced issue that might be bug please check Issues tab in github repository. In case you won't be able to find related issue please raise the issue following these rules:

* issue should contain login credentials to application at apex.oracle.com where issue is reproduced
* issue should contain steps to reproduce the issue in demo application
* issue should contain description about it's nature

### Paid support
In case you are not able to implement the plugin or you are willing to have custom implementation based on the plugin attributes (ie. custom JavaScript callbacks) we are willing to help you. Please send inquiry to apex[at]pretius.com with description what you want us to help you with. We will contact you as soon as possible with pricing and possible dates.
