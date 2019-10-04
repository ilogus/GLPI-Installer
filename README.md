# GLPI-Installer
Installeur automatique de GLPI (CentOS 7)

GLPI (Gestion libre de parc informatique) est un logiciel libre de gestion des services informatiques et de gestion des services d'assistance. Cette solution libre est éditée en PHP et distribuée sous licence GPL. En tant que technologie libre, toute personne peut exécuter, modifier ou développer le code qui est libre. (**[Wikipedia](https://fr.wikipedia.org/wiki/Gestion_libre_de_parc_informatique)**...)

## License (GLPI & GLPI-Installer)

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)

It is distributed under the GNU GENERAL PUBLIC LICENSE Version 2 - please consult the file called [COPYING](https://raw.githubusercontent.com/glpi-project/glpi/master/COPYING.txt) for more details.

## Prerequisites (GLPI)

* A web server (Apache, Nginx, IIS, etc.)
* MariaDB >= 10.0 or MySQL >= 5.6
* PHP 5.6 or higher
* Mandatory PHP extensions:
    - json
    - mbstring
    - iconv
    - mysqli
    - session
    - gd (picture generation)
    - curl (CAS authentication)

* Recommended PHP extensions (to enable optional features)
    - domxml (CAS authentication)
    - imap (mail collector and users authentication)
    - ldap (users authentication)
    - openssl (encrypted communication)

 * Supported browsers:
    - IE 11+
    - Edge
    - Firefox (including 2 latests ESR version)
    - Chrome

Please, consider using browsers on editor's supported version

## Documentation

Here is a [pdf version](https://forge.glpi-project.org/attachments/download/1901/glpidoc-0.85-en-partial.pdf).
We are working on a [markdown version](https://github.com/glpi-project/doc)


## Additional resources

* [Official website](https://glpi-project.org)
* [Github page ](https://github.com/glpi-project/)



[www.ilogus.dev](https://www.ilogus.dev)
