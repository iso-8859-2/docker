#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

# private docker registry
REGISTRY_URL="euler-registry.primeton.com"

PUSH_IMG="no"
RM_IMG="no"
LATEST="no"

# override this function
_dohelp() {
    echo "[WARN] Please override this function [_dohelp]."
}

# override this function
_doparse() {
    echo "[WARN] Please override this function [_doparse]. No parser implements to parse param \$1 = ${1}, \$2 = ${2}."
}

# override this function
main() {
    echo "[WARN] Please override this function [main]."
}
