* Encoding: UTF-8.

** select for Children with Chronic Conditions set .
dataset activate input_db .
dataset name hold_for_CCC .
dataset copy input_db .
dataset activate input_db .
IF  (CAHPS62 = 1 | CAHPS65 = 1 | CAHPS68 = 1 | CAHPS71 = 1 | CAHPS73 = 1)  any_CCC = 1 .
SELECT IF  (any_CCC = 1)  .
execute  .


** exit CCC select .
dataset activate hold_for_CCC .
dataset close input_db .
dataset activate hold_for_CCC .
dataset name input_db .

