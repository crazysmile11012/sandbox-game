heat key features:
- 22 - 20C default temp
- electricity flow makes heat
- collisions make heat
- depending on surface area of mesh the faster it equalizes with surrounding objects
- the higher the temp the more large the fluid sim collision sphere gets different fluids have different rates
- heat made by electricity is scaled depending on resistance and volt, amps,& watts
- programable logic controllers make heat the more scripts are running on it, also it scales with clockspeed, the plc has a copper plate for cooling
- logic gates make smaller amount of heat
- when materials reach their melting point they get subdivided (scales to quality) and turns into a fluid, when it cools to a solid temperature it turns each fluid particle into a predefined primitive and settles them for a second  and preforms a union operation making a solid (if other types of melted solids solidify they evenly distribute (unless density does not permit ))
- if there is nothing to offload heat to it emits a sphere collider around it to check for thermal conduits if it has nothing it stays (surface area heat dissipation to the air and fluids apply)
---
- if a fluid is labeled as flammable it heats up if touching spark (electricity) or other hot surfaces & when it reaches a flash point it makes a equal amount of smoke fluid (basically uses the heat expansion code and makes it exponential after a point and replaces it with smoke afterward ) while it is burning it makes colored shader effects depending on material close by and heat factors. it also makes particle effects to sell the fact its burning, the more exposed it is to open air more oxygen stat is applied, also using the fluid version of oxygen  it can be used to do the same thing, some materials are classified as monopropellant they burn without oxygen but the stats form oxygen can make them more efficient burning 
- when fluid is labeled as a refrigerant, it cools object it touches hen it goes thru faze change solid->liquid->gas or get uncompressed, they heat up when compressed they heat up when they go in phase change gas ->liquid->solid
---
- when heat travels between different objects and materials it has a inefficiency, this can be negated with the use of mercury or thermal paste and thermal grease
- (non world / editor (except outside WIP))light makes a small amount of heat in its sunspot
[[heat flow.canvas|heat flow]]