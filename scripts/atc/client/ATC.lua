--[TODO]

airports = {}

--INTERNATIONAL AIRPORT
	airports.ap1 = {}
	airports.ap1.Runways = {}
	airports.ap1.Runways.r1 = {}
	airports.ap1.Runways.r2 = {}

	airports.ap1.Name = "Panau International Airport"
	airports.ap1.Code = "ap1"
	airports.ap1.Location = Vector3(-6802, 208, -3626)

	--RUNWAY 1
	airports.ap1.Runways.r1.Name = "E - W Runway 1 (09 - 27)"
	airports.ap1.Runways.r1.Location = Vector3(-6256, 209, -3003)
	airports.ap1.Runways.r1.Code = "r1"
	airports.ap1.Runways.r1.Line1 = {Vector3(-5671.105957, 209.02, -3033.333008), Vector3(-6956.636230, 209.02, -3013.820801)}
	airports.ap1.Runways.r1.Line2 = {Vector3(-5670.010742, 209.02, -2991.025635), Vector3(-6956.455078, 209.02, -2971.491455)}
	airports.ap1.Runways.r1.Zone1 = Vector3(-6795, 209, -2995)
	airports.ap1.Runways.r1.Zone2 = Vector3(-6524, 209, -2999)
	airports.ap1.Runways.r1.Zone3 = Vector3(-6065, 209, -3006)
	airports.ap1.Runways.r1.Zone4 = Vector3(-5864, 209, -3009)

	--RUNWAY 2
	airports.ap1.Runways.r2.Name = "SW - NE Runway 2 (04 - 22)"
	airports.ap1.Runways.r2.Location = Vector3(-6205, 209, -3370)
	airports.ap1.Runways.r2.Code = "r2"
	airports.ap1.Runways.r2.Line1 = {Vector3(-5859.331543, 209.02, -3685.240723), Vector3(-6482.459473, 209.02, -3062.189209)}
	airports.ap1.Runways.r2.Line2 = {Vector3(-5890.069336, 209.02, -3715.299072), Vector3(-6512.651855, 209.02, -3092.270508)}
	airports.ap1.Runways.r2.Zone1 = Vector3(-6456, 209, -3120)
	airports.ap1.Runways.r2.Zone2 = Vector3(-6323, 209, -3252)
	airports.ap1.Runways.r2.Zone3 = Vector3(-6079, 209, -3496)
	airports.ap1.Runways.r2.Zone4 = Vector3(-5927, 209, -3648)
--END INTERNATIONAL AIRPORT

--AIRPORT 2
	airports.ap2 = {}
	airports.ap2.Runways = {}
	airports.ap2.Runways.r1 = {}
	airports.ap2.Runways.r2 = {}

	airports.ap2.Name = "Airport 2"
	airports.ap2.Code = "ap2"
	airports.ap2.Location = Vector3(-307, 313, 7098)

	--RUNWAY 1
	airports.ap2.Runways.r1.Name = "WNW - ESE Runway 1"
	airports.ap2.Runways.r1.Location = Vector3(-236, 295, 7139)
	airports.ap2.Runways.r1.Code = "r1"
	airports.ap2.Runways.r1.Line1 = {Vector3(-371.590515, 295.42, 7128.13183), Vector3(-154.819366, 295.42, 7161.583984)}
	airports.ap2.Runways.r1.Line2 = {Vector3(-368.539429, 295.42, 7107.087891), Vector3(-151.209930, 295.42, 7140.390625)}
	airports.ap2.Runways.r1.Zone1 = Vector3(-168, 296, 7149)
	airports.ap2.Runways.r1.Zone2 = Vector3(-353, 296, 7120)

	--RUNWAY 2
	airports.ap2.Runways.r2.Name = "WNW - ESE Runway 2"
	airports.ap2.Runways.r2.Location = Vector3(-236, 295, 7079)
	airports.ap2.Runways.r2.Code = "r2"
	airports.ap2.Runways.r2.Line1 = {Vector3(-359.723694, 295.42, 7048.352051), Vector3(-142.236694, 295.42, 7081.266113)}
	airports.ap2.Runways.r2.Line2 = {Vector3(-362.954529, 295.42, 7069.230957), Vector3(-145.421265, 295.42, 7102.350098)}
	airports.ap2.Runways.r2.Zone1 = Vector3(-160, 296, 7089)
	airports.ap2.Runways.r2.Zone2 = Vector3(-344, 296, 7061)
--END AIRPORT 2

--AIRPORT 3
	airports.ap3 = {}
	airports.ap3.Runways = {}
	airports.ap3.Runways.r1 = {}
	airports.ap3.Runways.r2 = {}

	airports.ap3.Name = "Airport 3"
	airports.ap3.Code = "ap3"
	airports.ap3.Location = Vector3(5827, 250, 6988)

	--RUNWAY 1
	airports.ap3.Runways.r1.Name = "N - S Runway"
	airports.ap3.Runways.r1.Location = Vector3(6044, 251, 6713)
	airports.ap3.Runways.r1.Code = "r1"
	airports.ap3.Runways.r1.Line1 = {Vector3(6066.141113, 251.065, 6255.662109), Vector3(6066.313477, 251.065, 7180.061035)}
	airports.ap3.Runways.r1.Line2 = {Vector3(6023.237793, 251.065, 6255.562500), Vector3(6023.227051, 251.065, 7180.131836)}
	airports.ap3.Runways.r1.Zone1 = Vector3(6044, 251, 6399)
	airports.ap3.Runways.r1.Zone2 = Vector3(6044, 251, 6560)
	airports.ap3.Runways.r1.Zone3 = Vector3(6044, 251, 6905)
	airports.ap3.Runways.r1.Zone4 = Vector3(6044, 251, 7100)


	--RUNWAY 2
	airports.ap3.Runways.r2.Name = "E - W Runway"
	airports.ap3.Runways.r2.Location = Vector3(5832, 251, 7159)
	airports.ap3.Runways.r2.Code = "r2"
	airports.ap3.Runways.r2.Line1 = {Vector3(5400.908203, 251.065, 7136.995605), Vector3(6281.921387, 251.065, 7137.173828)}
	airports.ap3.Runways.r2.Line2 = {Vector3(5400.959961, 251.065, 7179.914063), Vector3(6281.956543, 251.065, 7179.669434)}
	airports.ap3.Runways.r2.Zone1 = Vector3(6246, 252, 7158)
	airports.ap3.Runways.r2.Zone2 = Vector3(6026, 252, 7158)
	airports.ap3.Runways.r2.Zone3 = Vector3(5642, 252, 7158)
	airports.ap3.Runways.r2.Zone4 = Vector3(5446, 252, 7158)
--END AIRPORT 3

--DESERT AIRPORT 1
	airports.dap1 = {}
	airports.dap1.Runways = {}
	airports.dap1.Runways.r1 = {}
	airports.dap1.Runways.r2 = {}
	airports.dap1.Runways.r3 = {}

	airports.dap1.Name = "Desert Airport 1"
	airports.dap1.Code = "dap1"
	airports.dap1.Location = Vector3(-12127, 610, 4638)

	--RUNWAY 1
	airports.dap1.Runways.r1.Name = "NNE - SSW Runway 1 (03R - 21L)"
	airports.dap1.Runways.r1.Location = Vector3(-11970, 611, 4490)
	airports.dap1.Runways.r1.Code = "r1"
	airports.dap1.Runways.r1.Line1 = {Vector3(-11733.319336, 611.166, 4093.172363), Vector3(-12148.578125, 611.166, 4870.257813)}
	airports.dap1.Runways.r1.Line2 = {Vector3(-11771.141602, 611.166, 4073.083252), Vector3(-12186.385742, 611.166, 4850.160156)}
	airports.dap1.Runways.r1.Zone1 = Vector3(-12145, 612, 4817)
	airports.dap1.Runways.r1.Zone2 = Vector3(-12059, 612, 4656)
	airports.dap1.Runways.r1.Zone3 = Vector3(-11907, 612, 4373)
	airports.dap1.Runways.r1.Zone4 = Vector3(-11843, 612, 4253)

	--RUNWAY 2
	airports.dap1.Runways.r2.Name = "NNE - SSW Runway 2 (03L - 21R)"
	airports.dap1.Runways.r2.Location = Vector3(-12106, 611, 4412)
	airports.dap1.Runways.r2.Code = "r2"
	airports.dap1.Runways.r2.Line1 = {Vector3(-12323.192383, 611.166, 4777.071289), Vector3(-11907.872070, 611.166, 4000.303223)}
	airports.dap1.Runways.r2.Line2 = {Vector3(-12285.194336, 611.166, 4797.292969), Vector3(-11870.120117, 611.166, 4020.336426)}
	airports.dap1.Runways.r2.Zone1 = Vector3(-12280, 612, 4742)
	airports.dap1.Runways.r2.Zone2 = Vector3(-12195, 612, 4583)
	airports.dap1.Runways.r2.Zone3 = Vector3(-12031, 612, 4275)
	airports.dap1.Runways.r2.Zone4 = Vector3(-11956, 612, 4136)

	--RUNWAY 3
	airports.dap1.Runways.r3.Name = "WNW - ESE Runway (12 - 30)"
	airports.dap1.Runways.r3.Location = Vector3(-11968, 611, 4996)
	airports.dap1.Runways.r3.Code = "r3"
	airports.dap1.Runways.r3.Line1 = {Vector3(-12357.800781, 611.28, 4811.713867), Vector3(-11580.802734, 611.28, 5227.184570)}
	airports.dap1.Runways.r3.Line2 = {Vector3(-12337.531250, 611.28, 4774.079590), Vector3(-11560.554688, 611.28, 5189.380859)}
	airports.dap1.Runways.r3.Zone1 = Vector3(-12222, 612, 4860)
	airports.dap1.Runways.r3.Zone2 = Vector3(-12094, 612, 4929)
	airports.dap1.Runways.r3.Zone3 = Vector3(-11844, 612, 5062)
	airports.dap1.Runways.r3.Zone4 = Vector3(-11712, 612, 5132)
--END DESERT AIRPORT 1

--DESERT AIRPORT
	airports.dap2 = {}
	airports.dap2.Runways = {}
	airports.dap2.Runways.r1 = {}

	airports.dap2.Name = "Desert Airport 2"
	airports.dap2.Code = "dap2"
	airports.dap2.Location = Vector3(-7480, 1131, 11556)

	--RUNWAY 1
	airports.dap2.Runways.r1.Name = "NW - SE Runway"
	airports.dap2.Runways.r1.Location = Vector3(-6894, 1050, 11801)
	airports.dap2.Runways.r1.Code = "r1"
	airports.dap2.Runways.r1.Line1 = {Vector3(-7289.981934, 1050.4, 11588.232422), Vector3(-6534.480469, 1050.4, 12041.256836)}
	airports.dap2.Runways.r1.Line2 = {Vector3(-7266.576660, 1050.4, 11552.381836), Vector3(-6512.422852, 1050.4, 12004.443359)}
	airports.dap2.Runways.r1.Zone1 = Vector3(-7145, 1050, 11650)
	airports.dap2.Runways.r1.Zone2 = Vector3(-7017, 1050, 11727)
	airports.dap2.Runways.r1.Zone3 = Vector3(-6765, 1050, 11878)
	airports.dap2.Runways.r1.Zone4 = Vector3(-6629, 1050, 11960)
--END DESERT AIRPORT 2

--Teluk Permata Military Airport
	airports.tpma = {}
	airports.tpma.Runways = {}
	airports.tpma.Runways.r1 = {}

	airports.tpma.Name = "Teluk Permata Military Airport"
	airports.tpma.Code = "tpma"
	airports.tpma.Location = Vector3(-6869, 206, -10567)

	--RUNWAY 1
	airports.tpma.Runways.r1.Name = "NW - SE Runway"
	airports.tpma.Runways.r1.Location = Vector3(-6965, 206, -10719)
	airports.tpma.Runways.r1.Code = "r1"
	airports.tpma.Runways.r1.Line1 = {Vector3(-7125.049805, 205.99, -10835.092773), Vector3(-6811.123535, 205.99, -10631.134766)}
	airports.tpma.Runways.r1.Line2 = {Vector3(-7135.712402, 205.99, -10819.269531), Vector3(-6822.039551, 205.99, -10615.216797)}
	airports.tpma.Runways.r1.Zone1 = Vector3(-6849, 206, -10644)
	airports.tpma.Runways.r1.Zone2 = Vector3(-7086, 206, -10798)
--END Teluk Permata Military Airport

--Banjaran Gundin Military Airport
	airports.bgma = {}
	airports.bgma.Runways = {}
	airports.bgma.Runways.r1 = {}

	airports.bgma.Name = "Banjaran Gundin Military Airport"
	airports.bgma.Code = "bgma"
	airports.bgma.Location = Vector3(-4528, 434, -11471)

	--RUNWAY 1
	airports.bgma.Runways.r1.Name = "SW - NE Runway"
	airports.bgma.Runways.r1.Location = Vector3(-4821, 405, -11439)
	airports.bgma.Runways.r1.Code = "r1"
	airports.bgma.Runways.r1.Line1 = {Vector3(-5150.615234, 405.95, -11140.495117), Vector3(-4526.847656, 405.95, -11764.246094)}
	airports.bgma.Runways.r1.Line2 = {Vector3(-5119.368164, 405.95, -11109.314453), Vector3(-4495.647461, 405.95, -11733.138672)}
	airports.bgma.Runways.r1.Zone1 = Vector3(-4598, 405, -11661)
	airports.bgma.Runways.r1.Zone2 = Vector3(-4704, 405, -11556)
	airports.bgma.Runways.r1.Zone3 = Vector3(-4922, 405, -11338)
	airports.bgma.Runways.r1.Zone4 = Vector3(-5024, 405, -11235)
--END Banjaran Gundin Military Airport

--Sungai Cengkih Besar Military Airport
	airports.scbma = {}
	airports.scbma.Runways = {}
	airports.scbma.Runways.r1 = {}
	airports.scbma.Runways.r2 = {}

	airports.scbma.Name = "Sungai Cengkih Besar Military Airport"
	airports.scbma.Code = "scbma"
	airports.scbma.Location = Vector3(4498.164062, 213.065933, -10625.275391)

	--RUNWAY 1
	airports.scbma.Runways.r1.Name = "WNW - ESE Runway"
	airports.scbma.Runways.r1.Location = Vector3(4404.957520, 208.373535, -10739.606445)
	airports.scbma.Runways.r1.Code = "r1"
	airports.scbma.Runways.r1.Line1 = {Vector3(4804.708496, 208.50, -10587.829102), Vector3(3998.125000, 208.50, -10942.405273)}
	airports.scbma.Runways.r1.Line2 = {Vector3(4787.363770, 208.50, -10548.543945), Vector3(3980.776123, 208.50, -10903.388672)}
    airports.scbma.Runways.r1.Zone1 = Vector3(4645.379395, 208.373535, -10633.926758)
	airports.scbma.Runways.r1.Zone2 = Vector3(4214.037598, 208.373550, -10824.097656)
	airports.scbma.Runways.r1.Zone3 = Vector3(4609.331543, 208.373535, -10649.397461)
	airports.scbma.Runways.r1.Zone4 = Vector3(4027.442627, 208.373535, -10906.710938)

	--RUNWAY 2
	airports.scbma.Runways.r2.Name = "NNE - SSW Runway"
	airports.scbma.Runways.r2.Location = Vector3(4592.698730, 208.339966, -10733.783203)
	airports.scbma.Runways.r2.Code = "r2"
	airports.scbma.Runways.r2.Line1 = {Vector3(4441.359863, 208.50, -10332.921875), Vector3(4795.602539, 208.50, -11139.215820)}
	airports.scbma.Runways.r2.Line2 = {Vector3(4402.024902, 208.50, -10350.001953), Vector3(4756.696777, 208.50, -11156.482422)}
    airports.scbma.Runways.r2.Zone1 = Vector3(4486.581055, 208.339966, -10488.679688)
	airports.scbma.Runways.r2.Zone2 = Vector3(4660.750977, 208.338623, -10879.651367)
	airports.scbma.Runways.r2.Zone3 = Vector3(4513.131348, 208.339966, -10551.418945)
	airports.scbma.Runways.r2.Zone4 = Vector3(4757.638184, 208.339981, -11104.816406)
--END Sungai Cengkih Besar Military Airport

--Paya Luas Military Airport
	airports.plma = {}
	airports.plma.Runways = {}
	airports.plma.Runways.r1 = {}
	airports.plma.Runways.r2 = {}

	airports.plma.Name = "Paya Luas Military Airport"
	airports.plma.Code = "plma"
	airports.plma.Location = Vector3(12126.319336, 206.576889, -10664.407227)

	--RUNWAY 1
	airports.plma.Runways.r1.Name = "N - S Runway Runway 1 (18 - 36)"
	airports.plma.Runways.r1.Location = Vector3(12171.366211, 206.881302, -10519.047852)
	airports.plma.Runways.r1.Code = "r1"
	airports.plma.Runways.r1.Line1 = {Vector3(12192.611328, 206.99, -10952.471680), Vector3(12192.680664, 206.99, -10071.731445)}
	airports.plma.Runways.r1.Line2 = {Vector3(12150.144531, 206.99, -10952.653320), Vector3(12149.862305, 206.99, -10071.505859)}
    airports.plma.Runways.r1.Zone1 = Vector3(12171.115234, 206.881302, -10114.296875)
	airports.plma.Runways.r1.Zone2 = Vector3(12171.305664, 206.881302, -10316.319336)
	airports.plma.Runways.r1.Zone3 = Vector3(12171.076172, 206.880875, -10654.066406)
	airports.plma.Runways.r1.Zone4 = Vector3(12171.295898, 206.881302, -10791.271484)

	--RUNWAY 2
	airports.plma.Runways.r2.Name = "E - W Runway Runway 2 (09 - 27)"
	airports.plma.Runways.r2.Location = Vector3(11666.494141, 206.816544, -10713.845703)
	airports.plma.Runways.r2.Code = "r2"
	airports.plma.Runways.r2.Line1 = {Vector3(12193.009766, 206.99, -10736.407227), Vector3(11268.321289, 206.99, -10736.720703)}
	airports.plma.Runways.r2.Line2 = {Vector3(12191.907227, 206.99, -10693.890625), Vector3(11268.158203, 206.99, -10693.820313)}
    airports.plma.Runways.r2.Zone1 = Vector3(11987.235352, 206.881302, -10715.239258)
	airports.plma.Runways.r2.Zone2 = Vector3(11827.096680, 206.881302, -10715.252930)
	airports.plma.Runways.r2.Zone3 = Vector3(11488.982422, 206.880875, -10714.887695)
	airports.plma.Runways.r2.Zone4 = Vector3(11311.013672, 206.881302, -10714.862305)
--END Paya Luas Military Airport

--Lembah Delima Military Airport
	airports.ldma = {}
	airports.ldma.Runways = {}
	airports.ldma.Runways.r1 = {}

	airports.ldma.Name = "Lembah Delima Military Airport"
	airports.ldma.Code = "ldma"
	airports.ldma.Location = Vector3(9526.493164, 214.415009, 3786.812988)

	--RUNWAY 1
	airports.ldma.Runways.r1.Name = "NW - SE Runway (14 - 32)"
	airports.ldma.Runways.r1.Location = Vector3(9644.498047, 204.776703, 3818.911865)
	airports.ldma.Runways.r1.Code = "r1"
	airports.ldma.Runways.r1.Line1 = {Vector3(10010.864258, 204.85, 4107.849121), Vector3(9343.682617, 204.85, 3532.312012)}
	airports.ldma.Runways.r1.Line2 = {Vector3(9981.034180, 204.85, 4138.774414), Vector3(9315.699219, 204.85, 3564.541260)}
    airports.ldma.Runways.r1.Zone1 = Vector3(9361.733398, 204.777420, 3576.213867)
	airports.ldma.Runways.r1.Zone2 = Vector3(9502.890625, 204.714432, 3699.367432)
	airports.ldma.Runways.r1.Zone3 = Vector3(9761.981445, 204.716843, 3922.153809)
	airports.ldma.Runways.r1.Zone4 = Vector3(9874.945312, 204.776825, 4018.536621)
--END Lembah Delima Military Airport

--Cape Carnival Military Airport
	airports.ccma = {}
	airports.ccma.Runways = {}
	airports.ccma.Runways.r1 = {}
	airports.ccma.Runways.r2 = {}

	airports.ccma.Name = "Cape Carnival Military Airport"
	airports.ccma.Code = "ccma"
	airports.ccma.Location = Vector3(13780.503906, 245.339935, -2320.248047)

	--RUNWAY 1
	airports.ccma.Runways.r1.Name = "SSE - NNW Runway 1"
	airports.ccma.Runways.r1.Location = Vector3(13829.514648, 244.294357, -2417.442871)
	airports.ccma.Runways.r1.Code = "r1"
	airports.ccma.Runways.r1.Line1 = {Vector3(13691.849609, 239.63, -2616.742188), Vector3(13857.766602, 239.63, -2339.946533)}
	airports.ccma.Runways.r1.Line2 = {Vector3(13718.596680, 239.63, -2632.769775), Vector3(13884.477539, 239.62, -2355.998291)}
	airports.ccma.Runways.r1.Zone1 = Vector3(13691.849609, 239.569000, -2616.742188)
	airports.ccma.Runways.r1.Zone2 = Vector3(13857.766602, 239.565292, -2339.946533)
	airports.ccma.Runways.r1.Zone3 = Vector3(13884.477539, 239.552170, -2355.998291)
	airports.ccma.Runways.r1.Zone4 = Vector3(13718.596680, 239.568985, -2632.769775)

	--RUNWAY 2
	airports.ccma.Runways.r2.Name = "SSE - NNW Runway 2"
	airports.ccma.Runways.r2.Location = Vector3(13663.984375, 244.294357, -2319.651123)
	airports.ccma.Runways.r2.Code = "r2"
	airports.ccma.Runways.r2.Line1 = {Vector3(13526.248047, 239.63, -2518.767822), Vector3(13692.203125, 239.63, -2241.957275)}
	airports.ccma.Runways.r2.Line2 = {Vector3(13718.879883, 239.62, -2257.970703), Vector3(13552.955078, 239.63, -2534.780029)}
	airports.ccma.Runways.r2.Zone1 = Vector3(13526.248047, 239.568985, -2518.767822)
	airports.ccma.Runways.r2.Zone2 = Vector3(13692.203125, 239.565445, -2241.957275)
	airports.ccma.Runways.r2.Zone3 = Vector3(13718.879883, 239.557907, -2257.970703)
	airports.ccma.Runways.r2.Zone4 = Vector3(13552.955078, 239.568985, -2534.780029)
--END Cape Carnival Military Airport

--Kem Sungai Sejuk Military Airport
	airports.kssma = {}
	airports.kssma.Runways = {}
	airports.kssma.Runways.r1 = {}

	airports.kssma.Name = "Kem Sungai Sejuk Military Airport"
	airports.kssma.Code = "kssma"
	airports.kssma.Location = Vector3(827.527161, 303.839569, -4185.982422)

	--RUNWAY 1
	airports.kssma.Runways.r1.Name = "NE - SW Runway"
	airports.kssma.Runways.r1.Location = Vector3(827.527161, 298.839569, -4185.982422)
	airports.kssma.Runways.r1.Code = "r1"
	airports.kssma.Runways.r1.Line1 = {Vector3(916.460083, 298.45, -4252.363281), Vector3(502.987915, 298.85, -3796.223877)}
	airports.kssma.Runways.r1.Line2 = {Vector3(879.915588, 298.85, -4276.613770), Vector3(470.823334, 298.84, -3825.352783)}
    airports.kssma.Runways.r1.Zone1 = Vector3(916.460083, 299.016388, -4252.363281)
	airports.kssma.Runways.r1.Zone2 = Vector3(502.987915, 298.789551, -3796.223877)
	airports.kssma.Runways.r1.Zone3 = Vector3(470.823334, 298.780853, -3825.352783)
	airports.kssma.Runways.r1.Zone4 = Vector3(879.915588, 298.789551, -4276.613770)
--END Kem Sungai Sejuk Military Airport

listVisible = false
textVisible = true
getData = 0
runways = {}
prevMessageBeingShown = ""
messageBeingShown = ""
secondsSinceLastMessage = nil

--Main GUI
window = Window.Create()
window:SetVisible(false)
window:SetTitle("ATC Menu")
window:SetSizeRel(Vector2(0.75, 0.7))
window:SetPositionRel(Vector2(0.5, 0.5) - window.GetSizeRel(window) / 2)
runwayList = SortedList.Create(window)
runwayList:SetSizeRel(Vector2(1, 0.7))
runwayList:SetSize(runwayList:GetSize() - Vector2(11, 0))
runwayList:AddColumn("Name")
runwayList:AddColumn("Code")
runwayList:AddColumn("Location")
runwayList:AddColumn("Status")
runwayList:SetButtonsVisible(false)

legendRow = runwayList:AddItem("Name")
legendRow:SetCellText(1, "Code")
legendRow:SetCellText(2, "Location")
legendRow:SetCellText(3, "Status")

requestComboBox = ComboBox.Create(window)
requestComboBox:SetSizeRel(Vector2(0.5, 0.05))
requestComboBox:SetPositionRel(Vector2(0.25, 0.75))
requestComboBox:SetAlignment(GwenPosition.Center)
requestComboBox:AddItem("Send Requests to ATC", "default")
requestComboBox:AddItem("Request Takeoff")
requestComboBox:AddItem("Request Landing")
requestComboBox:AddItem("Declare Opening")
requestComboBox:AddItem("Request Teleport")
requestComboBox:AddItem("Set GPS")

quickrequestButton = Button.Create(window)
quickrequestButton:SetText("Quick Request")
quickrequestButton:SetSize(quickrequestButton:GetSize() * 3/2)
quickrequestButton:SetPositionRel(Vector2(0.5, 0.875) - quickrequestButton:GetSizeRel()/2)
quickrequestButton:SetAlignment(GwenPosition.Center)

quickrequestLabel = Label.Create(window)
quickrequestLabel:SetText("Hold 4 to do a quick request.")
quickrequestLabel:SizeToContents()
quickrequestLabel:SetPosition(window:GetSize() * 0.9 - quickrequestLabel:GetSize()/2)

function QuickRequest()
	local aprw = nil
	local UsedBy = nil
	local closestdist = 3000
	for ak, av in pairs(airports) do
		for rk, rv in pairs(av.Runways) do
			if runways[ak][rk].UsedBy == LocalPlayer then
				args = {}
				args.player = LocalPlayer
				args.id = ak.."."..rk
				Network:Send("reqOpening", args)
				return
			end
			if runways[ak][rk].UsedBy == nil then
				local pos = LocalPlayer:GetPosition()
				local dist = rv.Line1[1]:Distance(pos)
				if dist < closestdist then
					closestdist = dist
					aprw = ak.."."..rk
				end
				local dist = rv.Line1[2]:Distance(pos)
				if dist < closestdist then
					closestdist = dist
					aprw = ak.."."..rk
				end
				local dist = rv.Line2[1]:Distance(pos)
				if dist < closestdist then
					closestdist = dist
					aprw = ak.."."..rk
				end
				local dist = rv.Line2[2]:Distance(pos)
				if dist < closestdist then
					closestdist = dist
					aprw = ak.."."..rk
				end
			end
		end
	end
	args = {}
	args.player = LocalPlayer
	args.id = aprw
	if isInPlane(false) and Physics:Raycast(LocalPlayer:GetPosition(), Vector3.Down, 0, 10).distance == 10 then
		if closestdist < 3000 then
			Network:Send("reqLanding", args)
		else
			Chat:Print("Get closer to a runway to request a landing!", Color.Red)
		end
	else
		Network:Send("reqTakeoff", args)
	end
	closeWindow()
end

quickrequestButton:Subscribe("Press", QuickRequest)

function Selection()
	if runwayList:GetSelectedRow() ~= nil then
		if runwayList:GetSelectedRow():GetCellText(1) == "Code" then
			return
		end
		
		selected = requestComboBox:GetSelectedItem():GetText()
		
		if selected == "Request Takeoff" then
			for ak, av in pairs(airports) do
				for rk, rv in pairs(av.Runways) do
					if rv.UsedBy == LocalPlayer then
						Chat:Print("You have already reserved a different runway. Please cancel or proceed with that reservation.", Color.Red)
						return
					end
				end
			end
			args = {}
			args.player = LocalPlayer
			args.id = runwayList:GetSelectedRow():GetCellText(1)
			Network:Send("reqTakeoff", args)
			closeWindow()
			requestComboBox:SelectItemByName("default")
			return
		end
		if selected == "Request Landing" then
			for ak, av in pairs(airports) do
				for rk, rv in pairs(av.Runways) do
					 if rv.UsedBy == LocalPlayer then
						Chat:Print("You have already reserved a different runway. Please cancel or proceed with that reservation.", Color.Red)
						return
					end
				end
			end
			args = {}
			args.player = LocalPlayer
			args.id = runwayList:GetSelectedRow():GetCellText(1)
			Network:Send("reqLanding", args)
			closeWindow()
			requestComboBox:SelectItemByName("default")
			return
		end
		if selected == "Declare Opening" then
			args = {}
			args.player = LocalPlayer
			args.id = runwayList:GetSelectedRow():GetCellText(1)
			Network:Send("reqOpening", args)
			closeWindow()
			requestComboBox:SelectItemByName("default")
			return
		end
		if selected == "Request Teleport" then
			args = {}
			args.player = LocalPlayer
			args.id = runwayList:GetSelectedRow():GetCellText(1)
			Network:Send("reqTP", args)
			closeWindow()
			requestComboBox:SelectItemByName("default")
			return
		end
		if selected == "Set GPS" then
			gps(LocalPlayer, runwayList:GetSelectedRow():GetCellText(1))
			closeWindow()
			requestComboBox:SelectItemByName("default")
			return
		end
	end
	requestComboBox:SelectItemByName("default")
end

requestComboBox:Subscribe("Selection", Selection)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

runwayListRows = {}

for k, v in pairs(airports) do
	curAirportItem = runwayList:AddItem(v.Name)
	curAirportItem:SetCellText(1, tostring(v.Code))
	curAirportItem:SetCellText(2, tostring(round(v.Location.x, 1) .. ", " .. round(v.Location.y, 1) .. ", " .. round(v.Location.z, 1)))
	curAirportItem:SetBackgroundHoverColor(Color(200, 0, 0))
	curAirportItem:SetBackgroundEvenSelectedColor(Color(100, 0, 0))
	curAirportItem:SetBackgroundOddSelectedColor(Color(100, 0, 0))
	for k, v in pairs(v.Runways) do
		curRunwayItem = runwayList:AddItem("        " .. v.Name)
		curRunwayItem:SetCellText(1, tostring(curAirportItem:GetCellText(1) .. "." .. v.Code))
		curRunwayItem:SetCellText(2, tostring(round(v.Location.x, 1) .. ", " .. round(v.Location.y, 1) .. ", " .. round(v.Location.z, 1)))
		curRunwayItem:SetBackgroundHoverColor(Color(200, 0, 0))
		curRunwayItem:SetBackgroundEvenSelectedColor(Color(100, 0, 0))
		curRunwayItem:SetBackgroundOddSelectedColor(Color(100, 0, 0))
		runwayListRows[curRunwayItem:GetCellText(1)] = curRunwayItem
	end
	runwayListRows[curAirportItem:GetCellText(1)] = curAirportItem
end
runwayList:Sort(1)

function closeWindow()
	window:SetVisible(false)
	Mouse:SetVisible(false)
	Input:SetEnabled(true)
end

function resizeWindow()
	window:SetPositionRel(Vector2(0.5, 0.5) - window.GetSizeRel(window) / 2)
	runwayList:SetSizeRel(Vector2(1, 0.7))
	runwayList:SetSize(runwayList:GetSize() - Vector2(11, 0))
	requestComboBox:SetPositionRel(Vector2(0.25, 0.75))
end

function list(sender)
	if listVisible == false then
		listVisible = true
	else
		listVisible = false
	end
end

function text(sender)
	if textVisible == false then
		textVisible = true
	else
		textVisible = false
	end
end

function gps(sender, id)
	for ak, av in pairs(airports) do
		if id == ak then
			Waypoint:SetPosition(av.Location)
			if LocalPlayer:GetVehicle() ~= nil then
				vehicleOccupants = LocalPlayer:GetVehicle():GetOccupants()
				for pk, pv in pairs(vehicleOccupants) do
					info = {}
					info.player = pv
					info.location = av.Location
					Network:Send("sendServerGps", info)
				end
			end
			return
		end
		for rk, rv in pairs(av.Runways) do
			if id == ak .. "." .. rk then
				Waypoint:SetPosition(rv.Location)
				if LocalPlayer:GetVehicle() ~= nil then
					vehicleOccupants = LocalPlayer:GetVehicle():GetOccupants()
					for pk, pv in pairs(vehicleOccupants) do
						info = {}
						info.player = pv
						info.location = rv.Location
						Network:Send("sendServerGps", info)
					end
				end
			end
		end
	end
end

function recieveGps(location)
	Waypoint:SetPosition(location)
end

function gameRenderList()
	temprunways = runways
	if textVisible == true then
		for ak, av in pairs(airports) do
			if Vector3.Distance(av.Location, LocalPlayer:GetPosition()) < 3000 then
				for rk, rv in pairs(av.Runways) do
					if temprunways[ak] == nil or temprunways[ak][rk] == nil or LocalPlayer == nil then return end
					if temprunways[ak][rk].UsedBy == nil then
						Render:DrawLine(rv.Line1[1], rv.Line1[2], Color.Orange)
						Render:DrawLine(rv.Line2[1], rv.Line2[2], Color.Orange)
					elseif temprunways[ak][rk].UsedBy == LocalPlayer then
						Render:DrawLine(rv.Line1[1], rv.Line1[2], Color.Lime)
						Render:DrawLine(rv.Line2[1], rv.Line2[2], Color.Lime)
					else
						Render:DrawLine(rv.Line1[1], rv.Line1[2], Color.Red)
						Render:DrawLine(rv.Line2[1], rv.Line2[2], Color.Red)
					end
				end
			end
		end
	end
end
	
function renderList()
	temprunways = runways
	if (prevMessageBeingShown ~= messageBeingShown) then
		secondsSinceLastMessage = Timer()
	end
	if (secondsSinceLastMessage ~=nil and secondsSinceLastMessage:GetSeconds() < 5) then
		--Draw last message
		local message = string.split(messageBeingShown, ",")
		for i, m in pairs(message) do
			local rs = Render.Size
			local string = m
			local fontsize = 16
			local size = Render:GetTextSize ( string, fontsize )
			local x = rs.x - size.x - 5
			local y = rs.y * 0.5 - size.y/2 + (i * 20)
			Render:DrawText(Vector2(x, y) + Vector2(2, 2), string, Color(20, 20, 20, 85), fontsize)
			Render:DrawText(Vector2(x, y) + Vector2(1, 1), string, Color(20, 20, 20, 170), fontsize)
			Render:DrawText(Vector2(x, y), string, Color(0, 255, 255), fontsize)
		end
	end
	prevMessageBeingShown = messageBeingShown
	
	if (autoOpenTimer ~= nil) then
		if (autoOpenTimer:GetSeconds() < 20) then
			local rs = Render.Size
			local string = "Seconds Til Auto-Open: " .. string.format("%." .. (2) .. "f", (20 - autoOpenTimer:GetSeconds()))
			local fontsize = 16
			local size = Render:GetTextSize ( string, fontsize )
			local x = rs.x - size.x - 5
			local y = rs.y * 0.5 - size.y/2 + 300
			Render:DrawText(Vector2(x, y), string, Color(255, 0, 0), fontsize)
		else 
			autoOpenTimer = nil			
			temprunways[autoOpenAK][autoOpenRK].Status = "Open"
			temprunways[autoOpenAK][autoOpenRK].UsedBy = nil
			local info = {}
			info.id = autoOpenCode
			info.player = LocalPlayer
			Network:Send("openRunway", info)
			Events:Fire("AutoRunwayOpen") ----------------------------------------------------------------------------------------------------------------------- Going to use this to reward money.
		end
	end
	
	if Game:GetState() == GUIState.PDA or Game:GetState() == GUIState.Loading then return end
	--LABELS
	if textVisible == true and temprunways.ap1 ~= nil then
		for ak, av in pairs(airports) do
			if Vector3.Distance(av.Location, LocalPlayer:GetPosition()) < 3000 then
				textPos, isOnScreen = Render:WorldToScreen(av.Location + Vector3(0, 50, 0))
				if isOnScreen == true then
					Render:DrawText(textPos, "[" .. av.Code .. "] " .. av.Name, Color.Lime, 100, 0.25)
				end
			end
			for rk, rv in pairs(av.Runways) do
				if Vector3.Distance(rv.Location, LocalPlayer:GetPosition()) < 3000 then
					if temprunways == nil or temprunways[ak] == nil or temprunways[ak][rk] == nil then return end
					if temprunways[ak][rk].UsedBy ~= nil then
						textPos, isOnScreen = Render:WorldToScreen(rv.Location + Vector3(0, 50, 0))
						if isOnScreen == true then
							if temprunways[ak][rk].Enabled == false then
								Render:DrawText(textPos, "[" .. rv.Code .. "] " .. rv.Name .. " (Closed)", Color.Red, 100, 0.25)
							else
								Render:DrawText(textPos, "[" .. rv.Code .. "] " .. rv.Name .. " (" .. temprunways[ak][rk].UsedBy:GetName() .. " - " .. temprunways[ak][rk].Status .. ")", Color.Red, 100, 0.25)
							end
						end
					else
						textPos, isOnScreen = Render:WorldToScreen(rv.Location + Vector3(0, 50, 0))
						if isOnScreen == true then
							if temprunways[ak][rk].Enabled == false then
								Render:DrawText(textPos, "[" .. rv.Code .. "] " .. rv.Name .. " (Closed)", Color.Red, 100, 0.25)
							else
								Render:DrawText(textPos, "[" .. rv.Code .. "] " .. rv.Name .. " (Open)", Color.Lime, 100, 0.25)
							end
						end
					end
				end
			end
		end
	end

	--AUTO-OPEN
	if temprunways.ap1 ~= nil then
		for ak, av in pairs(airports) do
			for rk, rv in pairs(av.Runways) do
				if IsValid(temprunways[ak][rk].UsedBy) then
					if Vector3.Distance(rv.Location, LocalPlayer:GetPosition()) > 700 and temprunways[ak][rk].UsedBy == LocalPlayer and temprunways[ak][rk].Status == "Takeoff" then
						temprunways[ak][rk].Status = "Open"
						temprunways[ak][rk].UsedBy = nil
						local info = {}
						info.id = ak .. "." .. rk
						info.player = LocalPlayer
						Network:Send("openRunway", info)
					end
					if Vector3.Distance(rv.Location, LocalPlayer:GetPosition()) < 80 and temprunways[ak][rk].UsedBy == LocalPlayer and temprunways[ak][rk].Status == "Landing" then
						autoOpenTimer = Timer()
						autoOpenTimerText = true
						autoOpenAK = ak
						autoOpenRK = rk
						autoOpenCode = ak .. "."  .. rk
					end
				end
            end
		end
	end

	if getData == 50 then
		Network:Send("getRunwayData", LocalPlayer)
		getData = 0
	end
	getData = getData + 1
end

function checkIfComply()
	if airports ~= nil and airports.kssma ~= nil and airports.kssma.Runways ~= nil and airports.kssma.Runways.r1 ~= nil and airports.kssma.Runways.r1.Line2 ~= nil and runways ~= nil and runways.ap1 ~= nil and runways.ap1.r1 ~= nil then
		pos = LocalPlayer:GetPosition()
		horizdistance = 30
		vertdistance = 15
		if LocalPlayer:InVehicle() and LocalPlayer:GetVehicle():GetDriver() == LocalPlayer then --isInPlane(true) then
			for ak, av in pairs(airports) do
				for rk, rv in pairs(av.Runways) do
					if LocalPlayer == nil then return end
					if runways == nil then return end
					if runways[ak] == nil then return end
					if runways[ak][rk] == nil then return end
					if runways[ak][rk].UsedBy ~= nil and runways[ak][rk].UsedBy ~= LocalPlayer then
						for i = 0, 1, 0.01 do
							point = (rv.Line1[1] + (rv.Line2[1] - rv.Line1[1])/2) + (rv.Line1[2] - rv.Line1[1]) * i
							if Vector2(pos.x, pos.z):Distance(Vector2(point.x, point.z)) < horizdistance then
								if math.abs(point.y - pos.y) < vertdistance then
									Network:Send("RemoveVehicle")
									return
								end
							end
						end
					end
				end
			end
		end
	end
end

function isInPlane(checkPassenger)
	if LocalPlayer:GetVehicle() ~= nil then
		if LocalPlayer:GetVehicle():GetDriver() ~= LocalPlayer and checkPassenger == true then
			return false
		end
		if LocalPlayer:GetVehicle():GetName() == "Peek Airhawk 225" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Pell Silverbolt 6" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Cassius 192" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Si-47 Leopard" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "G9 Eclipse" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Aeroliner 474" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Bering I-86DP" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "F-33 DragonFly" then
			return true
		end
	end
	return false
end

function showMenu()
	window:SetVisible(true)
	Mouse:SetVisible(true)
	Input:SetEnabled(false)
end

function recieveRunwayData(runwayData)
	runways = runwayData
	for ak, av in pairs(airports) do
		for rk, rv in pairs(av.Runways) do
			if runways[ak][rk].Enabled == false then
				runwayListRows[ak .. "." .. rk]:SetCellText(3, "Closed")
			else
				if runways[ak][rk].UsedBy ~= nil then
					runwayListRows[ak .. "." .. rk]:SetCellText(3, tostring(runways[ak][rk].UsedBy) .. " - " .. runways[ak][rk].Status)
				else
					runwayListRows[ak .. "." .. rk]:SetCellText(3, tostring(runways[ak][rk].Status))
				end
			end
		end
	end
end

function keyUp(args)
	if args.key == string.byte("4") then
		if keydown_timer then keydown_timer = nil end
		if keyup_check then keyup_check = nil return end
		if window:GetVisible() == true then
			closeWindow(args.player)
		else
			showMenu(args.player)
		end
	end
end

function keyDown(args)
	if args.key == string.byte("4") then
		if keyup_check then return end
		if not keydown_timer then
			keydown_timer = Timer()
		elseif keydown_timer:GetSeconds() >= 0.5 then
			QuickRequest()
			keydown_timer = nil
			keyup_check = true
		end
	end
end

function PlayerChat(args)
	if isInPlane(false) == true then
		occupants = LocalPlayer:GetVehicle():GetOccupants()
		for ck, cv in pairs(occupants) do
			if cv == args.player then
				if LocalPlayer:GetVehicle():GetDriver() == cv then
					Chat:Print("[Pilot]" .. tostring(args.player) .. ": " .. tostring(args.text), args.player:GetColor())
					return false
				else
					Chat:Print("[In Plane]" .. tostring(args.player) .. ": " .. tostring(args.text), args.player:GetColor())
					return false
				end
			end
		end
	end
end

function receiveMessage(messageData)
	messageBeingShown = messageData.message
end

Network:Subscribe("recieveRunwayData", recieveRunwayData)
Network:Subscribe("sendGps", recieveGps)
Network:Subscribe("receiveMessage", receiveMessage)
window:Subscribe("WindowClosed", closeWindow)
window:Subscribe("Resize", resizeWindow)
Events:Subscribe("GameRender", gameRenderList)
Events:Subscribe("Render", renderList)
Events:Subscribe("Render", checkIfComply)
Events:Subscribe("KeyUp", keyUp)
Events:Subscribe("KeyDown", keyDown)
Events:Subscribe("PlayerChat", PlayerChat)