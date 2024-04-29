* Encoding: UTF-8.

** dummy case-mix variables (child) .
** general health status (child) .
DO IF (cahps53 > 0) .
compute health_exc = 0 .
compute health_vgd = 0 .
compute health_gd = 0 .
compute health_fair = 0 .
compute health_poor = 0 .
if (cahps53 = 1) health_exc = 1 .
if (cahps53 = 2) health_vgd = 1 .
if (cahps53 = 3) health_gd = 1 .
if (cahps53 = 4) health_fair = 1 .
if (cahps53 = 5) health_poor = 1 .
END IF .

** education (child) .
DO IF (cahps75 > 0) .
compute edu_8th = 0 .
compute edu_somehs = 0 .
compute edu_hs = 0 .
compute edu_somecoll = 0 .
compute edu_collgrad = 0 .
compute edu_morecoll = 0 .
if (cahps75 = 1) edu_8th = 1 .
if (cahps75 = 2) edu_somehs = 1 .
if (cahps75 = 3) edu_hs = 1 .
if (cahps75 = 4) edu_somecoll = 1 .
if (cahps75 = 5) edu_collgrad = 1 .
if (cahps75 = 6) edu_morecoll = 1 .
END IF .

execute .
