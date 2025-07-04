################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 2.5.0
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc
PYTHON_URLLIB3_LICENSE = MIT
PYTHON_URLLIB3_LICENSE_FILES = LICENSE.txt
PYTHON_URLLIB3_CPE_ID_VENDOR = python
PYTHON_URLLIB3_CPE_ID_PRODUCT = urllib3
PYTHON_URLLIB3_SETUP_TYPE = hatch
PYTHON_URLLIB3_DEPENDENCIES = host-python-hatch-vcs
HOST_PYTHON_URLLIB3_DEPENDENCIES = host-python-hatch-vcs

$(eval $(python-package))
$(eval $(host-python-package))
