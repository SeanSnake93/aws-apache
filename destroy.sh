#!/bin/bash
locking="false"
temp_location="eu-west-1"
cd Terraform/network/
echo ""
echo "        :::::::::  ::::::::: :::::::::: :::::::::: :::::::::   ::::::::  :::   :::  "
echo "       :+:    :+: :+:       :+:    :+:    :+:     :+:    :+: :+:    :+: :+:   :+:   "
echo "      +:+    +:+ +:+       +:+           +:+     +:+    +:+ +:+    +:+  +:+ +:+     "
echo "     +#+    +:+ +#++:++#  +#++:++#++    +#+     +#++:++#:  +#+    +:+   +#++:       "
echo "    +#+    +#+ +#+              +#+    +#+     +#+    +#+ +#+    +#+    +#+         "
echo "   #+#    #+# #+#       #+#    #+#    #+#     #+#    #+# #+#    #+#    #+#          "
echo "  #########  ######### #########     ###     ###    ###  ########     ###           "
echo ""
terraform destroy -var locked="${locking}" -var aws_location="${temp_location}" -auto-approve
echo ""