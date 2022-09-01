setwd('r/dataloader/')
source('south_scrape_funct.R')

### TEAMSTATS
ATL <- TeamStats('ATL')
BOS <- TeamStats('BOS')
BRK <- TeamStats('BRK')
CHO <- TeamStats('CHO')
CHI <- TeamStats('CHI')
CLE <- TeamStats('CLE')
DAL <- TeamStats('DAL')
DEN <- TeamStats('DEN')
DET <- TeamStats('DET')
GSW <- TeamStats('GSW')
HOU <- TeamStats('HOU')
IND <- TeamStats('IND')
LAC <- TeamStats('LAC')
LAL <- TeamStats('LAL')
MEM <- TeamStats('MEM')
MIA <- TeamStats('MIA')
MIL <- TeamStats('MIL')
MIN <- TeamStats('MIN')
NOP <- TeamStats('NOP')
NYK <- TeamStats('NYK')
OKC <- TeamStats('OKC')
ORL <- TeamStats('ORL')
PHI <- TeamStats('PHI')
PHO <- TeamStats('PHO')
POR <- TeamStats('POR')
SAC <- TeamStats('SAC')
SAS <- TeamStats('SAS')
TOR <- TeamStats('TOR')
UTA <- TeamStats('UTA')
WAS <- TeamStats('WAS')

Defenses.All <- rbind(ATL,BOS,BRK,CHO,CHI,CLE,DAL,DEN,DET,GSW,HOU,IND,LAC,LAL,MEM,MIA,MIL,MIN,NOP,NYK,OKC,ORL,PHI,PHO,POR,SAC,SAS,TOR,UTA,WAS)
Defenses.All[,1] <- as.character(Defenses.All[,1])


### INDIV
###################
###Atlanta Hawks###
###################

Kent.Bazemore.All <- PlayerStats('bazemke01', 'KENT.BAZEMORE')
Tim.Hardaway.All <- PlayerStats('hardati02', 'TIM.HARDAWAY')
Justin.Holiday.All <- PlayerStats('holidju01', 'JUSTIN.HOLIDAY')
Al.Horford.All <- PlayerStats('horfoal01', 'AL.HORFORD')
Kyle.Korver.All <- PlayerStats('korveky01', 'KYLE.KORVER')
Shelvin.Mack.All <- PlayerStats('macksh01', 'SHELVIN.MACK')
Paul.Millsap.All <- PlayerStats('millspa01', 'PAUL.MILLSAP')
Mike.Muscala.All <- PlayerStats('muscami01', 'MIKE.MUSCALA')
Lamar.Patterson.All <- PlayerStats('pattela01', 'LAMAR.PATTERSON')
Denis.Schroder.All <- PlayerStats('schrode01', 'DENNIS.SCHRODER')
Mike.Scott.All <- PlayerStats('scottmi01', 'MIKE.SCOTT')
Thabo.Sefolosha.All <- PlayerStats('sefolth01', 'THABO.SEFOLOSHA')
Tiago.Splitter.All <- PlayerStats('splitti01', 'TIAGO.SPLITTER')
Walter.Tavares.All <- PlayerStats('tavarwa01', 'WALTER.TAVARES')
Jeff.Teague.All <- PlayerStats('teaguje01', 'JEFF.TEAGUE')

Atlanta.Tm <- rbind(Kent.Bazemore.All, Tim.Hardaway.All, Justin.Holiday.All, Al.Horford.All,
                    Kyle.Korver.All, Shelvin.Mack.All, Paul.Millsap.All, Mike.Muscala.All, Lamar.Patterson.All,
                    Denis.Schroder.All, Mike.Scott.All, Thabo.Sefolosha.All, Tiago.Splitter.All,
                    Walter.Tavares.All, Jeff.Teague.All)

####################
###Boston Celtics###
####################

Avery.Bradley.All <- PlayerStats('bradlav01', 'AVERY.BRADLEY')
Jae.Crowder.All <- PlayerStats('crowdja01', 'JAE.CROWDER')
RJ.Hunter.All <- PlayerStats('hunterj01', 'RJ.HUNTER')
Jonas.Jerebko.All <- PlayerStats('jerebjo01', 'JONAS.JEREBKO')
Amir.Johnson.All <- PlayerStats('johnsam01', 'AMIR.JOHNSON')
David.Lee.All <- PlayerStats('leeda02', 'DAVID.LEE')
Jordan.Mickey.All <- PlayerStats('mickejo01', 'JORDAN.MICKEY')
Kelly.Olynyk.All <- PlayerStats('olynyke01', 'KELLY.OLYNYK')
Terry.Rozier.All <- PlayerStats('roziete01', 'TERRY.ROZIER')
Marcus.Smart.All <- PlayerStats('smartma01', 'MARCUS.SMART')
Jared.Sullinger.All <- PlayerStats('sullija01', 'JARED.SULLINGER')
Isaiah.Thomas.All <- PlayerStats('thomais02', 'ISAIAH.THOMAS')
Evan.Turner.All <- PlayerStats('turneev01', 'EVAN.TURNER')
James.Young.All <- PlayerStats('youngja01', 'JAMES.YOUNG')
Tyler.Zeller.All <- PlayerStats('zellety01', 'TYLER.ZELLER')

Boston.Tm <- rbind(Avery.Bradley.All, Jae.Crowder.All, RJ.Hunter.All, Jonas.Jerebko.All,
                   Amir.Johnson.All, David.Lee.All, Jordan.Mickey.All, Kelly.Olynyk.All,
                   Terry.Rozier.All, Marcus.Smart.All, Jared.Sullinger.All, Isaiah.Thomas.All,
                   Evan.Turner.All, James.Young.All, Tyler.Zeller.All)

###################
###Brooklyn Nets###
###################

Andrea.Bargnani.All <- PlayerStats('bargnan01', 'ANDREA.BARGNANI')
Bojan.Bogdanovic.All <- PlayerStats('bogdabo02', 'BOJAN.BOGDANOVIC')
Markel.Brown.All <- PlayerStats('brownma02', 'MARKEL.BROWN')
Wayne.Ellington.All <- PlayerStats('ellinwa01', 'WAYNE.ELLINGTON')
Rondae.Hollis.Jefferson.All <- PlayerStats('holliro01', 'RONDAE.HOLLIS.JEFFERSON')
Jarrett.Jack.All <- PlayerStats('jackja01', 'JARRETT.JACK')
Joe.Johnson.All <- PlayerStats('johnsjo02', 'JOE.JOHNSON')
Sergey.Karasev.All <- PlayerStats('karasse01', 'SERGEY.KARASEV')
Shane.Larkin.All <- PlayerStats('larkish01', 'SHANE.LARKIN')
Brook.Lopez.All <- PlayerStats('lopezbr01', 'BROOK.LOPEZ')
Willie.Reed.All <- PlayerStats('reedwi02', 'WILLIE.REED')
Thomas.Robinson.All <- PlayerStats('robinth01', 'THOMAS.ROBINSON')
Donald.Sloan.All <- PlayerStats('sloando01', 'DONALD.SLOAN')
Thaddeus.Young.All <- PlayerStats('youngth01', 'THADDEUS.YOUNG')

Brooklyn.Tm <- rbind(Andrea.Bargnani.All, Bojan.Bogdanovic.All, Markel.Brown.All,
                     Wayne.Ellington.All, Rondae.Hollis.Jefferson.All, Jarrett.Jack.All,
                     Joe.Johnson.All, Sergey.Karasev.All, Shane.Larkin.All, Brook.Lopez.All,
                     Willie.Reed.All, Thomas.Robinson.All, Donald.Sloan.All, Thaddeus.Young.All)

###################
###Chicago Bulls###
###################

Cameron.Bairstow.All <- PlayerStats('bairsca01', 'CAMERON.BAIRSTOW')
Aaron.Brooks.All <- PlayerStats('brookaa01', 'AARON.BROOKS')
Jimmy.Butler.All <- PlayerStats('butleji01', 'JIMMY.BUTLER')
Mike.Dunleavy.All <- PlayerStats('dunlemi02', 'MIKE.DUNLEAVY')
Cristiano.Felicio.All <- PlayerStats('feliccr01', 'CRISTIANO.FELICIO')
Pau.Gasol.All <- PlayerStats('gasolpa01', 'PAU.GASOL')
Taj.Gibson.All <- PlayerStats('gibsota01', 'TAJ.GIBSON')
Kirk.Hinrich.All <- PlayerStats('hinriki01', 'KIRK.HINRICH')
Doug.McDermott.All <- PlayerStats('mcderdo01', 'DOUG.MCDERMOTT')
Nikola.Mirotic.All <- PlayerStats('mirotni01', 'NIKOLA.MIROTIC')
E.Twaun.Moore.All <- PlayerStats('mooreet01', 'ETWAUN.MOORE')
Joakim.Noah.All <- PlayerStats('noahjo01', 'JOAKIM.NOAH')
Bobby.Portis.All <- PlayerStats('portibo01', 'BOBBY.PORTIS')
Derrick.Rose.All <- PlayerStats('rosede01', 'DERRICK.ROSE')
Tony.Snell.All <- PlayerStats('snellto01', 'TONY.SNELL')

Chicago.Tm <- rbind(Cameron.Bairstow.All, Aaron.Brooks.All, Jimmy.Butler.All, Mike.Dunleavy.All, Cristiano.Felicio.All, 
                    Pau.Gasol.All, Taj.Gibson.All, Kirk.Hinrich.All, Doug.McDermott.All, Nikola.Mirotic.All,
                    E.Twaun.Moore.All, Joakim.Noah.All, Bobby.Portis.All, Derrick.Rose.All, Tony.Snell.All)

#######################
###Charlotte Hornets###
#######################

Nicolas.Batum.All <- PlayerStats('batumni01', 'NICOLAS.BATUM')
Troy.Daniels.All <- PlayerStats('danietr01', 'TROY.DANIELS')
PJ.Hairston.All <- PlayerStats('hairspj02', 'PJ.HAIRSTON')
Tyler.Hansbrough.All <- PlayerStats('hansbty01', 'TYLER.HANSBROUGH')
Aaron.Harrison.All <- PlayerStats('harriaa01', 'AARON.HARRISON')
Spencer.Hawes.All <- PlayerStats('hawessp01', 'SPENCER.HAWES')
Al.Jefferson.All <- PlayerStats('jeffeal01', 'AL.JEFFERSON')
Frank.Kaminsky.All <- PlayerStats('kaminfr01', 'FRANK.KAMINSKY')
Michael.Kidd.Gilchrist.All <- PlayerStats('kiddgmi01', 'MICHAEL.KIDD.GILCHRIST')
Jeremy.Lamb.All <- PlayerStats('lambje01', 'JEREMY.LAMB')
Jeremy.Lin.All <- PlayerStats('linje01', 'JEREMY.LIN')
Brian.Roberts.All <- PlayerStats('roberbr01', 'BRIAN.ROBERTS')
Kemba.Walker.All <- PlayerStats('walkeke02', 'KEMBA.WALKER')
Marvin.Williams.All <- PlayerStats('willima01', 'MARVIN.WILLIAMS')
Cody.Zeller.All <- PlayerStats('zelleco01', 'CODY.ZELLER')

Charlotte.Tm <- rbind(Nicolas.Batum.All, Troy.Daniels.All, PJ.Hairston.All, Tyler.Hansbrough.All,
                      Aaron.Harrison.All, Spencer.Hawes.All, Al.Jefferson.All, Frank.Kaminsky.All, Michael.Kidd.Gilchrist.All,
                      Jeremy.Lamb.All, Jeremy.Lin.All,  Brian.Roberts.All, Kemba.Walker.All, Marvin.Williams.All, Cody.Zeller.All)

#########################
###Cleveland Cavaliers###
#########################

Jared.Cunningham.All <- PlayerStats('cunnija01', 'JARED.CUNNINGHAM')
Matthew.Dellavedova.All <- PlayerStats('dellama01', 'MATTHEW.DELLAVEDOVA')
Joe.Harris.All <- PlayerStats('harrijo01', 'JOE.HARRIS')
Kyrie.Irving.All <- PlayerStats('irvinky01', 'KYRIE.IRVING')
LeBron.James.All <- PlayerStats('jamesle01', 'LEBRON.JAMES')
Richard.Jefferson.All <- PlayerStats('jefferi01', 'RICHARD.JEFFERSON')
James.Jones.All <- PlayerStats('jonesja02', 'JAMES.JONES')
Sasha.Kaun.All <- PlayerStats('kaunsa01', 'SASHA.KAUN')
Kevin.Love.All <- PlayerStats('loveke01', 'KEVIN.LOVE')
Timofey.Mozgov.All <- PlayerStats('mozgoti01', 'TIMOFEY.MOZGOV')
Iman.Shumpert.All <- PlayerStats('shumpim01', 'IMAN.SHUMPERT')
JR.Smith.All <- PlayerStats('smithjr01', 'JR.SMITH')
Tristan.Thompson.All <- PlayerStats('thomptr01', 'TRISTAN.THOMPSON')
Anderson.Varejao.All <- PlayerStats('varejan01', 'ANDERSON.VAREJAO')
Mo.Williams.All <- PlayerStats('willima01', 'MO.WILLIAMS')

Cleveland.Tm <- rbind(Jared.Cunningham.All, Matthew.Dellavedova.All,
                      Joe.Harris.All, Kyrie.Irving.All, LeBron.James.All, Richard.Jefferson.All, James.Jones.All,
                      Sasha.Kaun.All, Kevin.Love.All, Timofey.Mozgov.All, Iman.Shumpert.All, JR.Smith.All, 
                      Tristan.Thompson.All, Anderson.Varejao.All, Mo.Williams.All)

######################
###Dallas Mavericks###
######################

Justin.Anderson.All <- PlayerStats('anderju01', 'JUSTIN.ANDERSON')
JJ.Barea.All <- PlayerStats('bareajo01', 'JJ.BAREA')
Jeremy.Evans.All <- PlayerStats('evansje01', 'JEREMY.EVANS')
Raymond.Felton.All <- PlayerStats('feltora01', 'RAYMOND.FELTON')
Devin.Harris.All <- PlayerStats('harride01', 'DEVIN.HARRIS')
John.Jenkins.All <- PlayerStats('jenkijo01', 'JOHN.JENKINS')
Wesley.Matthews.All <- PlayerStats('matthwe02', 'WESLEY.MATTHEWS')
JaVale.McGee.All <- PlayerStats('mcgeeja01', 'JAVALE.MCGEE')
Salah.Mejri.All <- PlayerStats('mejrisa01', 'SALAH.MEJRI')
Dirk.Nowitzki.All <- PlayerStats('nowitdi01', 'DIRK.NOWITZKI')
Zaza.Pachulia.All <- PlayerStats('pachuza01', 'ZAZA.PACHULIA')
Chandler.Parsons.All <- PlayerStats('parsoch01', 'CHANDLER.PARSONS')
Dwight.Powell.All <- PlayerStats('poweldw01', 'DWIGHT.POWELL')
Charlie.Villanueva.All <- PlayerStats('villach01', 'CHARLIE.VILLANUEVA')
Deron.Williams.All <- PlayerStats('willide01', 'DERON.WILLIAMS')

Dallas.Tm <- rbind(Justin.Anderson.All, JJ.Barea.All, Jeremy.Evans.All,
                   Raymond.Felton.All, Devin.Harris.All, John.Jenkins.All, Wesley.Matthews.All, JaVale.McGee.All,
                   Salah.Mejri.All, Dirk.Nowitzki.All, Zaza.Pachulia.All, Chandler.Parsons.All,
                   Dwight.Powell.All, Charlie.Villanueva.All, Deron.Williams.All)

####################
###Denver Nuggets###
####################

Darrell.Arthur.All <- PlayerStats('arthuda01', 'DARRELL.ARTHUR')
Will.Barton.All <- PlayerStats('bartowi01', 'WILL.BARTON')
Wilson.Chandler.All <- PlayerStats('chandwi01', 'WILSON.CHANDLER')
Kenneth.Faried.All <- PlayerStats('farieke01', 'KENNETH.FARIED')
Randy.Foye.All <- PlayerStats('foyera01', 'RANDY.FOYE')
Danilo.Gallinari.All <- PlayerStats('gallida01', 'DANILO.GALLINARI')
#Erick.Green.All <- PlayerStats('greener01', 'ERICK.GREEN')
Gary.Harris.All <- PlayerStats('harriga01', 'GARY.HARRIS')
JJ.Hickson.All <- PlayerStats('hicksjj01', 'JJ.HICKSON')
Nikola.Jokic.All <- PlayerStats('jokicni01', 'NIKOLA.JOKIC')
Joffrey.Lauvergne.All <- PlayerStats('lauvejo01', 'JOFFREY.LAUVERGNE')
Mike.Miller.All <- PlayerStats('millemi01', 'MIKE.MILLER')
Emmanuel.Mudiay.All <- PlayerStats('mudiaem01', 'EMMANUEL.MUDIAY')
Jameer.Nelson.All <- PlayerStats('nelsoja01', 'JAMEER.NELSON')
Jusuf.Nurkic.All <- PlayerStats('nurkiju01', 'JUSUF.NURKIC')
Kostas.Papanikolaou.All <- PlayerStats('papanko01', 'KOSTAS.PAPANIKOLAOU')

Denver.Tm <- rbind(Darrell.Arthur.All, Will.Barton.All, Wilson.Chandler.All, Kenneth.Faried.All,
                   Randy.Foye.All, Danilo.Gallinari.All, Gary.Harris.All, JJ.Hickson.All, Nikola.Jokic.All,
                   Joffrey.Lauvergne.All, Mike.Miller.All, Emmanuel.Mudiay.All, Jameer.Nelson.All,
                   Jusuf.Nurkic.All, Kostas.Papanikolaou.All)

#####################
###Detroit Pistons###
#####################

Joel.Anthony.All <- PlayerStats('anthojo01', 'JOEL.ANTHONY')
Aron.Baynes.All <- PlayerStats('baynear01', 'ARON.BAYNES')
Steve.Blake.All <- PlayerStats('blakest01', 'STEVE.BLAKE')
Reggie.Bullock.All <- PlayerStats('bullore01', 'REGGIE.BULLOCK')
Kentavious.Caldwell.Pope.All <- PlayerStats('caldwke01', 'KENTAVIOUS.CALDWELL.POPE')
Spencer.Dinwiddie.All <- PlayerStats('dinwisp01', 'SPENCER.DINWIDDIE')
Andre.Drummond.All <- PlayerStats('drumman01', 'ANDRE.DRUMMOND')
Darrun.Hilliard.All <- PlayerStats('hillida01', 'DARRUN.HILLIARD')
Ersan.Ilyasova.All <- PlayerStats('ilyaser01', 'ERSAN.ILYASOVA')
Reggie.Jackson.All <- PlayerStats('jacksre01', 'REGGIE.JACKSON')
Brandon.Jennings.All <- PlayerStats('jennibr01', 'BRANDON.JENNINGS')
Stanley.Johnson.All <- PlayerStats('johnsst04', 'STANLEY.JOHNSON')
Jodie.Meeks.All <- PlayerStats('meeksjo01', 'JODIE.MEEKS')
Marcus.Morris.All <- PlayerStats('morrima03', 'MARCUS.MORRIS')
Anthony.Tolliver.All <- PlayerStats('tollian01', 'ANTHONY.TOLLIVER')

Detroit.Tm <- rbind(Joel.Anthony.All, Aron.Baynes.All, Steve.Blake.All, Reggie.Bullock.All,
                    Kentavious.Caldwell.Pope.All, Spencer.Dinwiddie.All, Andre.Drummond.All, Darrun.Hilliard.All,
                    Ersan.Ilyasova.All,  Reggie.Jackson.All, Brandon.Jennings.All, Stanley.Johnson.All, 
                    Jodie.Meeks.All, Marcus.Morris.All, Anthony.Tolliver.All)

###########################
###Golden State Warriors###
###########################

Leandro.Barbosa.All <- PlayerStats('barbole01', 'LEANDRO.BARBOSA')
Harrison.Barnes.All <- PlayerStats('barneha02', 'HARRISON.BARNES')
Andrew.Bogut.All <- PlayerStats('bogutan01', 'ANDREW.BOGUT')
Ian.Clark.All <- PlayerStats('clarkia01', 'IAN.CLARK')
Stephen.Curry.All <- PlayerStats('curryst01', 'STEPHEN.CURRY')
Festus.Ezeli.All <- PlayerStats('ezelife01', 'FESTUS.EZELI')
Draymond.Green.All <- PlayerStats('greendr01', 'DRAYMOND.GREEN')
Andre.Iguodala.All <- PlayerStats('iguodan01', 'ANDRE.IGUODALA')
Shaun.Livingston.All <- PlayerStats('livinsh01', 'SHAUN.LIVINGSTON')
James.Michael.McAdoo.All <- PlayerStats('mcadoja01', 'JAMES.MICHAEL.MCADOO')
Brandon.Rush.All <- PlayerStats('rushbr01', 'BRANDON.RUSH')
Marreese.Speights.All <- PlayerStats('speigma01', 'MARREESE.SPEIGHTS')
Jason.Thompson.All <- PlayerStats('thompja02', 'JASON.THOMPSON')
Klay.Thompson.All <- PlayerStats('thompkl01', 'KLAY.THOMPSON')

Golden.State.Tm <- rbind(Leandro.Barbosa.All, Harrison.Barnes.All, Andrew.Bogut.All,
                         Ian.Clark.All, Stephen.Curry.All, Festus.Ezeli.All, Draymond.Green.All,
                         Andre.Iguodala.All, Shaun.Livingston.All, James.Michael.McAdoo.All,
                         Brandon.Rush.All, Marreese.Speights.All, Jason.Thompson.All, Klay.Thompson.All)

#####################
###Houston Rockets###
#####################

Trevor.Ariza.All <- PlayerStats('arizatr01', 'TREVOR.ARIZA')
Patrick.Beverley.All <- PlayerStats('beverpa01', 'PATRICK.BEVERLEY')
Corey.Brewer.All <- PlayerStats('breweco01', 'COREY.BREWER')
Clint.Capela.All <- PlayerStats('capelca01', 'CLINT.CAPELA')
Sam.Dekker.All <- PlayerStats('dekkesa01', 'SAM.DEKKER')
James.Harden.All <- PlayerStats('hardeja01', 'JAMES.HARDEN')
Montrezl.Harrell.All <- PlayerStats('harremo01', 'MONTREZL.HARRELL')
#Chuck.Hayes.All <- PlayerStats('hayesch01', 'CHUCK.HAYES')
Dwight.Howard.All <- PlayerStats('howardw01', 'DWIGHT.HOWARD')
Terrence.Jones.All <- PlayerStats('joneste01', 'TERRENCE.JONES')
Ty.Lawson.All <- PlayerStats('lawsoty01', 'TY.LAWSON')
KJ.McDaniels.All <- PlayerStats('mcdankj01', 'KJ.MCDANIELS')
Donatas.Motiejunas.All <- PlayerStats('motiedo01', 'DONATAS.MOTIEJUNAS')
Jason.Terry.All <- PlayerStats('terryja01', 'JASON.TERRY')
Marcus.Thornton.All <- PlayerStats('thornma01', 'MARCUS.THORNTON')

Houston.Tm <- rbind(Trevor.Ariza.All, Patrick.Beverley.All, Corey.Brewer.All,
                    Clint.Capela.All, Sam.Dekker.All, James.Harden.All, Montrezl.Harrell.All, 
                    Dwight.Howard.All, Terrence.Jones.All, Ty.Lawson.All,
                    KJ.McDaniels.All, Donatas.Motiejunas.All, Jason.Terry.All, Marcus.Thornton.All)

####################
###Indiana Pacers###
####################

Lavoy.Allen.All <- PlayerStats('allenla01', 'LAVOY.ALLEN')
Chase.Budinger.All <- PlayerStats('budinch01', 'CHASE.BUDINGER')
Monta.Ellis.All <- PlayerStats('ellismo01', 'MONTA.ELLIS')
Paul.George.All <- PlayerStats('georgpa01', 'PAUL.GEORGE')
George.Hill.All <- PlayerStats('hillge01', 'GEORGE.HILL')
Jordan.Hill.All <- PlayerStats('hilljo01', 'JORDAN.HILL')
Solomon.Hill.All <- PlayerStats('hillso01', 'SOLOMON.HILL')
Ian.Mahinmi.All <- PlayerStats('mahinia01', 'IAN.MAHINMI')
CJ.Miles.All <- PlayerStats('milescj01', 'CJ.MILES')
Glenn.Robinson.III.All <- PlayerStats('robingl02', 'GLENN.ROBINSON.III')
Rodney.Stuckey.All <- PlayerStats('stuckro01', 'RODNEY.STUCKEY')
Myles.Turner.All <- PlayerStats('turnemy01', 'MYLES.TURNER')
Shayne.Wittington.All <- PlayerStats('whittsh01', 'SHAYNE.WHITTINGTON')
Joseph.Young.All <- PlayerStats('youngjo01', 'JOE.YOUNG')

Indiana.Tm <- rbind(Lavoy.Allen.All, Chase.Budinger.All, Monta.Ellis.All,
                    Paul.George.All, George.Hill.All, Jordan.Hill.All, Solomon.Hill.All,
                    Ian.Mahinmi.All, CJ.Miles.All, Rodney.Stuckey.All, Myles.Turner.All,
                    Shayne.Wittington.All, Joseph.Young.All)

##########################
###Los Angeles Clippers###
##########################

Cole.Aldrich.All <- PlayerStats('aldrico01', 'COLE.ALDRICH')
Jamal.Crawford.All <- PlayerStats('crawfja01', 'JAMAL.CRAWFORD')
Branden.Dawson.All <- PlayerStats('dawsobr01', 'BRANDEN.DAWSON')
Blake.Griffin.All <- PlayerStats('griffbl01', 'BLAKE.GRIFFIN')
Wesley.Johnson.All <- PlayerStats('johnswe01', 'WESLEY.JOHNSON')
DeAndre.Jordan.All <- PlayerStats('jordade01', 'DEANDRE.JORDAN')
Luc.Mbah.a.Moute.All <- PlayerStats('mbahalu01', 'LUC.RICHARD.MBAH.A.MOUTE')
Chris.Paul.All <- PlayerStats('paulch01', 'CHRIS.PAUL')
Paul.Pierce.All <- PlayerStats('piercpa01', 'PAUL.PIERCE')
Pablo.Prigioni.All <- PlayerStats('prigipa01', 'PABLO.PRIGIONI')
JJ.Redick.All <- PlayerStats('redicjj01', 'JJ.REDICK')
Austin.Rivers.All <- PlayerStats('riverau01', 'AUSTIN.RIVERS')
Josh.Smith.All <- PlayerStats('smithjo03', 'JOSH.SMITH')
Lance.Stephenson.All <- PlayerStats('stephla01', 'LANCE.STEPHENSON')

LA.Clippers.Tm <- rbind(Cole.Aldrich.All, Jamal.Crawford.All, Branden.Dawson.All, Blake.Griffin.All,
                        Wesley.Johnson.All, DeAndre.Jordan.All, Luc.Mbah.a.Moute.All, Paul.Pierce.All,
                        Chris.Paul.All, Pablo.Prigioni.All, JJ.Redick.All, Austin.Rivers.All, 
                        Josh.Smith.All, Lance.Stephenson.All)

########################
###Los Angeles Lakers###
########################

Brandon.Bass.All <- PlayerStats('bassbr01', 'BRANDON.BASS')
Tarik.Black.All <- PlayerStats('blackta01', 'TARIK.BLACK')
Anthony.Brown.All <- PlayerStats('brownan02', 'ANTHONY.BROWN')
Kobe.Bryant.All <- PlayerStats('bryanko01', 'KOBE.BRYANT')
Jordan.Clarkson.All <- PlayerStats('clarkjo01', 'JORDAN.CLARKSON')
Roy.Hibbert.All <- PlayerStats('hibbero01', 'ROY.HIBBERT')
Marcelo.Huertas.All <- PlayerStats('huertma01', 'MARCELO.HUERTAS')
Ryan.Kelly.All <- PlayerStats('kellyry01', 'RYAN.KELLY')
Larry.Nance.Jr.All <- PlayerStats('nancela02', 'LARRY.NANCE.JR')
Julius.Randle.All <- PlayerStats('randlju01', 'JULIUS.RANDLE')
DAngelo.Russell.All <- PlayerStats('russeda01', 'DANGELO.RUSSELL')
Robert.Sacre.All <- PlayerStats('sacrero01', 'ROBERT.SACRE')
Lou.Williams.All <- PlayerStats('willilo02', 'LOU.WILLIAMS')
Metta.World.Peace.All <- PlayerStats('artesro01', 'METTA.WORLD.PEACE')
Nick.Young.All <- PlayerStats('youngni01', 'NICK.YOUNG')

LA.Lakers.Tm <- rbind(Brandon.Bass.All, Tarik.Black.All, Anthony.Brown.All,
                      Kobe.Bryant.All, Jordan.Clarkson.All, Roy.Hibbert.All, Marcelo.Huertas.All,
                      Ryan.Kelly.All, Larry.Nance.Jr.All, Julius.Randle.All, DAngelo.Russell.All, Robert.Sacre.All,
                      Lou.Williams.All, Metta.World.Peace.All, Nick.Young.All)

#######################
###Memphis Grizzlies###
#######################

Jordan.Adams.All <- PlayerStats('adamsjo01', 'JORDAN.ADAMS')
Tony.Allen.All <- PlayerStats('allento01', 'TONY.ALLEN')
Matt.Barnes.All <- PlayerStats('barnema02', 'MATT.BARNES')
Vince.Carter.All <- PlayerStats('cartevi01', 'VINCE.CARTER')
Mario.Chalmers.All <- PlayerStats('chalmma01', 'MARIO.CHALMERS')
Mike.Conley.All <- PlayerStats('conlemi01', 'MIKE.CONLEY')
James.Ennis.All <- PlayerStats('ennisja01', 'JAMES.ENNIS')
Jordan.Farmar.All <- PlayerStats('farmajo01', 'JORDAN.FARMAR')
Marc.Gasol.All <- PlayerStats('gasolma01', 'MARC.GASOL')
JaMychal.Green.All <- PlayerStats('greenja01', 'JAMYCHAL.GREEN')
Jeff.Green.All <- PlayerStats('greenje02', 'JEFF.GREEN')
Ryan.Hollins.All <- PlayerStats('holliry01', 'RYAN.HOLLINS')
Courtney.Lee.All <- PlayerStats('leeco01', 'COURTNEY.LEE')
Jarell.Martin.All <- PlayerStats('martija01', 'JARELL.MARTIN')
Zach.Randolph.All <- PlayerStats('randoza01', 'ZACH.RANDOLPH')
Russ.Smith.All <- PlayerStats('smithru01', 'RUSS.SMITH')
Jarnell.Stokes.All <- PlayerStats('stokeja01', 'JARNELL.STOKES')
Brandan.Wright.All <- PlayerStats('wrighbr03', 'BRANDAN.WRIGHT')

Memphis.Tm <- rbind(Jordan.Adams.All, Tony.Allen.All, Matt.Barnes.All, Vince.Carter.All, 
                    Mario.Chalmers.All, Mike.Conley.All, James.Ennis.All, Jordan.Farmar.All, Marc.Gasol.All, JaMychal.Green.All,
                    Jeff.Green.All, Ryan.Hollins.All, Courtney.Lee.All, Jarell.Martin.All, Zach.Randolph.All, 
                    Russ.Smith.All, Jarnell.Stokes.All, Brandan.Wright.All)

################
###Miami Heat###
################

Chris.Andersen.All <- PlayerStats('anderch01', 'CHRIS.ANDERSEN')
Chris.Bosh.All <- PlayerStats('boshch01', 'CHRIS.BOSH')
Luol.Deng.All <- PlayerStats('denglu01', 'LUOL.DENG')
Goran.Dragic.All <- PlayerStats('dragigo01', 'GORAN.DRAGIC')
Gerald.Green.All <- PlayerStats('greenge01', 'GERALD.GREEN')
Udonis.Haslem.All <- PlayerStats('hasleud01', 'UDONIS.HASLEM')
Tyler.Johnson.All <- PlayerStats('johnsty01', 'TYLER.JOHNSON')
Josh.McRoberts.All <- PlayerStats('mcrobjo01', 'JOSH.MCROBERTS')
Josh.Richardson.All <- PlayerStats('richajo01', 'JOSH.RICHARDSON')
Amare.Stoudemire.All <- PlayerStats('stoudam01', 'AMARE.STOUDEMIRE')
Beno.Udrih.All <- PlayerStats('udrihbe01', 'BENO.UDRIH')
Dwayne.Wade.All <- PlayerStats('wadedw01', 'DWYANE.WADE')
Hassan.Whiteside.All <- PlayerStats('whiteha01', 'HASSAN.WHITESIDE')
Justice.Winslow.All <- PlayerStats('winslju01', 'JUSTISE.WINSLOW')

Miami.Tm <- rbind(Chris.Andersen.All, Chris.Bosh.All, Luol.Deng.All, Goran.Dragic.All, 
                  Gerald.Green.All, Udonis.Haslem.All, Tyler.Johnson.All, Josh.McRoberts.All, Amare.Stoudemire.All, 
                  Beno.Udrih.All, Dwayne.Wade.All, Hassan.Whiteside.All, Justice.Winslow.All)

#####################
###Milwaukee Bucks###
#####################

Giannis.Antetokounmpo.All <- PlayerStats('antetgi01', 'GIANNIS.ANTETOKOUNMPO')
Jerryd.Bayless.All <- PlayerStats('bayleje01', 'JERRYD.BAYLESS')
Michael.Carter.Williams.All <- PlayerStats('cartemi01', 'MICHAEL.CARTER.WILLIAMS')
Chris.Copeland.All <- PlayerStats('copelch01', 'CHRIS.COPELAND')
Tyler.Ennis.All <- PlayerStats('ennisty01', 'TYLER.ENNIS')
John.Henson.All <- PlayerStats('hensojo01', 'JOHN.HENSON')
Damien.Inglis.All <- PlayerStats('inglida01', 'DAMIEN.INGLIS')
OJ.Mayo.All <- PlayerStats('mayooj01', 'OJ.MAYO')
Khris.Middleton.All <- PlayerStats('middlkh01', 'KHRIS.MIDDLETON')
Greg.Monroe.All <- PlayerStats('monrogr01', 'GREG.MONROE')
Johnny.OBryant.All <- PlayerStats('obryajo01', 'JOHNNY.OBRYANT')
Jabari.Parker.All <- PlayerStats('parkeja01', 'JABARI.PARKER')
Miles.Plumlee.All <- PlayerStats('plumlmi01', 'MILES.PLUMLEE')
Greivis.Vasquez.All <- PlayerStats('vasqugr01', 'GREIVIS.VASQUEZ')
Rashad.Vaughn.All <- PlayerStats('vaughra01', 'RASHAD.VAUGHN')

Milwaukee.Tm <- rbind(Giannis.Antetokounmpo.All, Jerryd.Bayless.All, Michael.Carter.Williams.All, 
                      Chris.Copeland.All, Tyler.Ennis.All, John.Henson.All, Damien.Inglis.All, OJ.Mayo.All,
                      Khris.Middleton.All, Greg.Monroe.All, Johnny.OBryant.All, Jabari.Parker.All,
                      Miles.Plumlee.All, Greivis.Vasquez.All, Rashad.Vaughn.All)

############################
###Minnesota Timberwolves###
############################

Nemanja.Bjelica.All <- PlayerStats('bjeline01', 'NEMANJA.BJELICA')
Gorgui.Dieng.All <- PlayerStats('dienggo01', 'GORGUI.DIENG')
Kevin.Garnett.All <- PlayerStats('garneke01', 'KEVIN.GARNETT')
Tyus.Jones.All <- PlayerStats('jonesty01', 'TYUS.JONES')
Zach.Lavine.All <- PlayerStats('lavinza01', 'ZACH.LAVINE')
Kevin.Martin.All <- PlayerStats('martike02', 'KEVIN.MARTIN')
Shabazz.Muhammad.All <- PlayerStats('muhamsh01', 'SHABAZZ.MUHAMMAD')
Adreian.Payne.All <- PlayerStats('paynead01', 'ADREIAN.PAYNE')
#Nikola.Pekovic.All <- PlayerStats('pekovni01', 'NIKOLA.PEKOVIC')
Tayshaun.Prince.All <- PlayerStats('princta01', 'TAYSHAUN.PRINCE')
Ricky.Rubio.All <- PlayerStats('rubiori01', 'RICKY.RUBIO')
Damjan.Rudez.All <- PlayerStats('rudezda01', 'DAMJAN.RUDEZ')
Karl.Anthony.Towns.All <- PlayerStats('townska01', 'KARL.ANTHONY.TOWNS')
Andrew.Wiggins.All <- PlayerStats('wiggian01', 'ANDREW.WIGGINS')

Minnesota.Tm <- rbind(Nemanja.Bjelica.All, Gorgui.Dieng.All, Kevin.Garnett.All, Tyus.Jones.All,
                      Zach.Lavine.All, Kevin.Martin.All, Shabazz.Muhammad.All, Adreian.Payne.All,
                      Tayshaun.Prince.All, Ricky.Rubio.All, Damjan.Rudez.All, Karl.Anthony.Towns.All,
                      Andrew.Wiggins.All)

##########################
###New Orleans Pelicans###
##########################

Alexis.Ajinca.All <- PlayerStats('ajincal01', 'ALEXIS.AJINCA')
Ryan.Anderson.All <- PlayerStats('anderry01', 'RYAN.ANDERSON')
Omer.Asik.All <- PlayerStats('asikom01', 'OMER.ASIK')
Luke.Babbitt.All <- PlayerStats('babbilu01', 'LUKE.BABBITT')
Norris.Cole.All <- PlayerStats('coleno01', 'NORRIS.COLE')
Dante.Cunningham.All <- PlayerStats('cunnida01', 'DANTE.CUNNINGHAM')
Anthony.Davis.All <- PlayerStats('davisan02', 'ANTHONY.DAVIS')
Toney.Douglas.All <- PlayerStats('douglto01', 'TONEY.DOUGLAS')
Tyreke.Evans.All <- PlayerStats('evansty01', 'TYREKE.EVANS')
#Jimmer.Fredette.All <- PlayerStats('fredeji01', 'JIMMER.FREDETTE')
Alonzo.Gee.All <- PlayerStats('geeal01', 'ALONZO.GEE')
Eric.Gordon.All <- PlayerStats('gordoer01', 'ERIC.GORDON')
Jrue.Holiday.All <- PlayerStats('holidjr01', 'JRUE.HOLIDAY')
Kendrick.Perkins.All <- PlayerStats('perkike01', 'KENDRICK.PERKINS')
#Quincy.Pondexter.All <- PlayerStats('pondequ01', 'QUINCY.PONDEXTER')
#Nate.Robinson.All <- PlayerStats('robinna01', 'NATE.ROBINSON')

New.Orleans.Tm <- rbind(Alexis.Ajinca.All, Ryan.Anderson.All, Omer.Asik.All, Luke.Babbitt.All, 
                        Norris.Cole.All, Dante.Cunningham.All, Anthony.Davis.All, Toney.Douglas.All, Tyreke.Evans.All,
                        Alonzo.Gee.All, Eric.Gordon.All, Jrue.Holiday.All, Kendrick.Perkins.All)

#####################
###New York Knicks###
#####################

Arron.Afflalo.All <- PlayerStats('afflaar01', 'ARRON.AFFLALO')
Lou.Amundson.All <- PlayerStats('amundlo01', 'LOU.AMUNDSON')
Carmelo.Anthony.All <- PlayerStats('anthoca01', 'CARMELO.ANTHONY')
Jose.Calderon.All <- PlayerStats('caldejo01', 'JOSE.CALDERON')
Cleanthony.Early.All <- PlayerStats('earlycl01', 'CLEANTHONY.EARLY')
Langston.Galloway.All <- PlayerStats('gallola01', 'LANGSTON.GALLOWAY')
Jerian.Grant.All <- PlayerStats('grantje02', 'JERIAN.GRANT')
Robin.Lopez.All <- PlayerStats('lopezro01', 'ROBIN.LOPEZ')
Kyle.OQuinn.All <- PlayerStats('oquinky01', 'KYLE.OQUINN')
Kristaps.Porzingis.All <- PlayerStats('porzikr01', 'KRISTAPS.PORZINGIS')
Kevin.Seraphin.All <- PlayerStats('serapke01', 'KEVIN.SERAPHIN')
Lance.Thomas.All <- PlayerStats('thomala01', 'LANCE.THOMAS')
Sasha.Vujacic.All <- PlayerStats('vujacsa01', 'SASHA.VUJACIC')
Derrick.Williams.All <- PlayerStats('willide02', 'DERRICK.WILLIAMS')

New.York.Tm <- rbind(Arron.Afflalo.All, Lou.Amundson.All, Carmelo.Anthony.All, Jose.Calderon.All,
                     Cleanthony.Early.All, Langston.Galloway.All, Jerian.Grant.All, Robin.Lopez.All, Kyle.OQuinn.All,
                     Kristaps.Porzingis.All, Kevin.Seraphin.All, Lance.Thomas.All, Sasha.Vujacic.All,
                     Derrick.Williams.All)

###########################
###Oklahoma City Thunder###
###########################

Steven.Adams.All <- PlayerStats('adamsst01', 'STEVEN.ADAMS')
DJ.Augustin.All <- PlayerStats('augusdj01', 'DJ.AUGUSTIN')
Nick.Collison.All <- PlayerStats('collini01', 'NICK.COLLISON')
Kevin.Durant.All <- PlayerStats('duranke01', 'KEVIN.DURANT')
Serge.Ibaka.All <- PlayerStats('ibakase01', 'SERGE.IBAKA')
Enes.Kanter.All <- PlayerStats('kanteen01', 'ENES.KANTER')
Mitch.McGary.All <- PlayerStats('mcgarmi01', 'MITCH.MCGARY')
Anthony.Morrow.All <- PlayerStats('morroan01', 'ANTHONY.MORROW')
Steve.Novak.All <- PlayerStats('novakst01', 'STEVE.NOVAK')
Cameron.Payne.All <- PlayerStats('payneca01', 'CAMERON.PAYNE')
Andre.Roberson.All <- PlayerStats('roberan03', 'ANDRE.ROBERSON')
Kyle.Singler.All <- PlayerStats('singlky01', 'KYLE.SINGLER')
Dion.Waiters.All <- PlayerStats('waitedi01', 'DION.WAITERS')
Russell.Westbrook.All <- PlayerStats('westbru01', 'RUSSELL.WESTBROOK')

Oklahoma.City.Tm <- rbind(Steven.Adams.All, DJ.Augustin.All, Nick.Collison.All,
                          Kevin.Durant.All, Serge.Ibaka.All, Enes.Kanter.All, Mitch.McGary.All,
                          Anthony.Morrow.All, Steve.Novak.All, Cameron.Payne.All, Andre.Roberson.All, 
                          Kyle.Singler.All, Dion.Waiters.All, Russell.Westbrook.All)

###################
###Orlando Magic###
###################

Dewayne.Dedmon.All <- PlayerStats('dedmode01', 'DEWAYNE.DEDMON')
Evan.Fournier.All <- PlayerStats('fournev01', 'EVAN.FOURNIER')
Channing.Frye.All <- PlayerStats('fryech01', 'CHANNING.FRYE')
Aaron.Gordon.All <- PlayerStats('gordoaa01', 'AARON.GORDON')
Tobias.Harris.All <- PlayerStats('harrito02', 'TOBIAS.HARRIS')
Mario.Hezonja.All <- PlayerStats('hezonma01', 'MARIO.HEZONJA')
Devyn.Marble.All <- PlayerStats('marblde01', 'DEVYN.MARBLE')
Shabazz.Napier.All <- PlayerStats('napiesh01', 'SHABAZZ.NAPIER')
Andrew.Nicholson.All <- PlayerStats('nichoan01', 'ANDREW.NICHOLSON')
Victor.Oladipo.All <- PlayerStats('oladivi01', 'VICTOR.OLADIPO')
Elfrid.Payton.All <- PlayerStats('paytoel01', 'ELFRID.PAYTON')
Jason.Smith.All <- PlayerStats('smithja02', 'JASON.SMITH')
Nikola.Vucevic.All <- PlayerStats('vucevni01', 'NIKOLA.VUCEVIC')
CJ.Watson.All <- PlayerStats('watsocj01', 'CJ.WATSON')

Orlando.Tm <- rbind(Dewayne.Dedmon.All, Evan.Fournier.All, Channing.Frye.All,
                    Aaron.Gordon.All, Tobias.Harris.All, Mario.Hezonja.All, Devyn.Marble.All, 
                    Shabazz.Napier.All, Andrew.Nicholson.All, Victor.Oladipo.All, Elfrid.Payton.All, 
                    Jason.Smith.All, Nikola.Vucevic.All, CJ.Watson.All)

########################
###Philadelphia 76ers###
########################

Isaiah.Canaan.All <- PlayerStats('canaais01', 'ISAIAH.CANAAN')
Robert.Covington.All <- PlayerStats('covinro01', 'ROBERT.COVINGTON')
Jerami.Grant.All <- PlayerStats('grantje01', 'JERAMI.GRANT')
Richaun.Holmes.All <- PlayerStats('holmeri01', 'RICHAUN.HOLMES')
Carl.Landry.All <- PlayerStats('landrca01', 'CARL.LANDRY')
Kendall.Marshall.All <- PlayerStats('marshke01', 'KENDALL.MARSHALL')
TJ.McConnell.All <- PlayerStats('mccontj01', 'TJ.MCCONNELL')
Nerlens.Noel.All <- PlayerStats('noelne01', 'NERLENS.NOEL')
Jahlil.Okafor.All <- PlayerStats('okafoja01', 'JAHLIL.OKAFOR')
Phil.Pressey.All <- PlayerStats('pressph01', 'PHIL.PRESSEY')
Jakarr.Sampson.All <- PlayerStats('sampsja02', 'JAKARR.SAMPSON')
Ish.Smith.All <- PlayerStats('smithis01', 'ISH.SMITH')
Nik.Stauskas.All <- PlayerStats('stausni01', 'NIK.STAUSKAS')
Hollis.Thompson.All <- PlayerStats('thompho01', 'HOLLIS.THOMPSON')
Christian.Wood.All <- PlayerStats('woodch01', 'CHRISTIAN.WOOD')
Tony.Wroten.All <- PlayerStats('wroteto01', 'TONY.WROTEN')

Philadelphia.Tm <- rbind(Isaiah.Canaan.All, Robert.Covington.All, Jerami.Grant.All,
                         Richaun.Holmes.All, Carl.Landry.All, Kendall.Marshall.All, TJ.McConnell.All, Nerlens.Noel.All, 
                         Jahlil.Okafor.All, Phil.Pressey.All, Jakarr.Sampson.All, Ish.Smith.All, Nik.Stauskas.All, 
                         Hollis.Thompson.All, Christian.Wood.All, Tony.Wroten.All)

##################
###Phoenix Suns###
##################

Eric.Bledsoe.All <- PlayerStats('bledser01', 'ERIC.BLEDSOE')
Devin.Booker.All <- PlayerStats('bookede01', 'DEVIN.BOOKER')
Tyson.Chandler.All <- PlayerStats('chandty01', 'TYSON.CHANDLER')
Bryce.Cotton.All <- PlayerStats('cottobr01', 'BRYCE.COTTON')
Archie.Goodwin.All <- PlayerStats('goodwar01', 'ARCHIE.GOODWIN')
Cory.Jefferson.All <- PlayerStats('jeffeco01', 'CORY.JEFFERSON')
Brandon.Knight.All <- PlayerStats('knighbr03', 'BRANDON.KNIGHT')
Alex.Len.All <- PlayerStats('lenal01', 'ALEX.LEN')
Jon.Leuer.All <- PlayerStats('leuerjo01', 'JON.LEUER')
Markieff.Morris.All <- PlayerStats('morrima02', 'MARKIEFF.MORRIS')
Ronnie.Price.All <- PlayerStats('pricero01', 'RONNIE.PRICE')
Mirza.Teletovic.All <- PlayerStats('teletmi01', 'MIRZA.TELETOVIC')
PJ.Tucker.All <- PlayerStats('tuckepj01', 'PJ.TUCKER')
TJ.Warren.All <- PlayerStats('warretj01', 'TJ.WARREN')
Sonny.Weems.All <- PlayerStats('weemsso01', 'SONNY.WEEMS')

Phoenix.Tm <- rbind(Eric.Bledsoe.All, Devin.Booker.All, Tyson.Chandler.All, Bryce.Cotton.All,
                    Archie.Goodwin.All, Cory.Jefferson.All, Brandon.Knight.All, Alex.Len.All, Jon.Leuer.All,
                    Markieff.Morris.All, Ronnie.Price.All, Mirza.Teletovic.All, PJ.Tucker.All,
                    TJ.Warren.All, Sonny.Weems.All)

###########################
###Portland Trailblazers###
###########################

Cliff.Alexander.All <- PlayerStats('alexacl01', 'CLIFF.ALEXANDER')
Al.Farouq.Aminu.All <- PlayerStats('aminual01', 'AL.FAROUQ.AMINU')
Pat.Connaughton.All <- PlayerStats('connapa01', 'PAT.CONNAUGHTON')
Allen.Crabbe.All <- PlayerStats('crabbal01', 'ALLEN.CRABBE')
Ed.Davis.All <- PlayerStats('davised01', 'ED.DAVIS')
Tim.Frazier.All <- PlayerStats('fraziti01', 'TIM.FRAZIER')
Maurice.Harkless.All <- PlayerStats('harklma01', 'MAURICE.HARKLESS')
Gerald.Henderson.All <- PlayerStats('hendege02', 'GERALD.HENDERSON')
Chris.Kaman.All <- PlayerStats('kamanch01', 'CHRIS.KAMAN')
Meyers.Leonard.All <- PlayerStats('leoname01', 'MEYERS.LEONARD')
Damian.Lillard.All <- PlayerStats('lillada01', 'DAMIAN.LILLARD')
CJ.McCollum.All <- PlayerStats('mccolcj01', 'CJ.MCCOLLUM')
Luis.Montero.All <- PlayerStats('montelu01', 'LUIS.MONTERO')
Mason.Plumlee.All <- PlayerStats('plumlma01', 'MASON.PLUMLEE')
Noah.Vonleh.All <- PlayerStats('vonleno01', 'NOAH.VONLEH')

Portland.Tm <- rbind(Cliff.Alexander.All, Al.Farouq.Aminu.All, Pat.Connaughton.All, 
                     Allen.Crabbe.All, Ed.Davis.All, Tim.Frazier.All, Maurice.Harkless.All, Gerald.Henderson.All,
                     Chris.Kaman.All, Meyers.Leonard.All, Damian.Lillard.All, CJ.McCollum.All, Luis.Montero.All, 
                     Mason.Plumlee.All, Noah.Vonleh.All)

######################
###Sacramento Kings###
######################

Quincy.Acy.All <- PlayerStats('acyqu01', 'QUINCY.ACY')
James.Anderson.All <- PlayerStats('anderja01', 'JAMES.ANDERSON')
Marco.Belinelli.All <- PlayerStats('belinma01', 'MARCO.BELINELLI')
Caron.Butler.All <- PlayerStats('butleca01', 'CARON.BUTLER')
Omri.Casspi.All <- PlayerStats('casspom01', 'OMRI.CASSPI')
Willie.Cauley.Stein.All <- PlayerStats('caulewi01', 'WILLIE.CAULEY.STEIN')
Darren.Collison.All <- PlayerStats('collida01', 'DARREN.COLLISON')
DeMarcus.Cousins.All <- PlayerStats('couside01', 'DEMARCUS.COUSINS')
Seth.Curry.All <- PlayerStats('curryse01', 'SETH.CURRY')
Rudy.Gay.All <- PlayerStats('gayru01', 'RUDY.GAY')
Kosta.Koufos.All <- PlayerStats('koufoko01', 'KOSTA.KOUFOS')
Ben.McLemore.All <- PlayerStats('mclembe01', 'BEN.MCLEMORE')
Eric.Moreland.All <- PlayerStats('moreler01', 'ERIC.MORELAND')
Rajon.Rondo.All <- PlayerStats('rondora01', 'RAJON.RONDO')

Sacramento.Tm <- rbind(Quincy.Acy.All, James.Anderson.All, Marco.Belinelli.All, 
                       Caron.Butler.All, Omri.Casspi.All, Willie.Cauley.Stein.All, Darren.Collison.All, 
                       DeMarcus.Cousins.All, Seth.Curry.All, Rudy.Gay.All, Kosta.Koufos.All, Ben.McLemore.All,
                       Eric.Moreland.All, Rajon.Rondo.All)

#######################
###San Antonio Spurs###
#######################

LaMarcus.Aldridge.All <- PlayerStats('aldrila01', 'LAMARCUS.ALDRIDGE')
Kyle.Anderson.All <- PlayerStats('anderky01', 'KYLE.ANDERSON')
Matt.Bonner.All <- PlayerStats('bonnema01', 'MATT.BONNER')
Rasual.Butler.All <- PlayerStats('butlera01', 'RASUAL.BUTLER')
Boris.Diaw.All <- PlayerStats('diawbo01', 'BORIS.DIAW')
Tim.Duncan.All <- PlayerStats('duncati01', 'TIM.DUNCAN')
Manu.Ginobili.All <- PlayerStats('ginobma01', 'MANU.GINOBILI')
Danny.Green.All <- PlayerStats('greenda02', 'DANNY.GREEN')
Kawhi.Leonard.All <- PlayerStats('leonaka01', 'KAWHI.LEONARD')
Boban.Marjanovic.All <- PlayerStats('marjabo01', 'BOBAN.MARJANOVIC')
Ray.McCallum.All <- PlayerStats('mccalra01', 'RAY.MCCALLUM')
Patty.Mills.All <- PlayerStats('millspa02', 'PATTY.MILLS')
Tony.Parker.All <- PlayerStats('parketo01', 'TONY.PARKER')
Jonathon.Simmons.All <- PlayerStats('simmojo02', 'JONATHON.SIMMONS')
David.West.All <- PlayerStats('westda01', 'DAVID.WEST')

San.Antonio.Tm <- rbind(LaMarcus.Aldridge.All, Kyle.Anderson.All, Matt.Bonner.All, 
                        Rasual.Butler.All, Boris.Diaw.All, Tim.Duncan.All, Manu.Ginobili.All, Danny.Green.All,
                        Kawhi.Leonard.All, Boban.Marjanovic.All, Ray.McCallum.All, Patty.Mills.All,
                        Tony.Parker.All, Jonathon.Simmons.All, David.West.All)

#####################
###Toronto Raptors###
#####################

Anthony.Bennett.All <- PlayerStats('bennean01', 'ANTHONY.BENNETT')
Bismack.Biyombo.All <- PlayerStats('biyombi01', 'BISMACK.BIYOMBO')
Bruno.Caboclo.All <- PlayerStats('cabocbr01', 'BRUNO.CABOCLO')
DeMarre.Carroll.All <- PlayerStats('carrode01', 'DEMARRE.CARROLL')
DeMar.DeRozan.All <- PlayerStats('derozde01', 'DEMAR.DEROZAN')
James.Johnson.All <- PlayerStats('johnsja01', 'JAMES.JOHNSON')
Cory.Joseph.All <- PlayerStats('josepco01', 'CORY.JOSEPH')
Kyle.Lowry.All <- PlayerStats('lowryky01', 'KYLE.LOWRY')
Lucas.Nogueira.All <- PlayerStats('noguelu01', 'LUCAS.NOGUEIRA')
Patrick.Patterson.All <- PlayerStats('pattepa01', 'PATRICK.PATTERSON')
Norman.Powell.All <- PlayerStats('powelno01', 'NORMAN.POWELL')
Terrance.Ross.All <- PlayerStats('rosste01', 'TERRENCE.ROSS')
Luis.Scola.All <- PlayerStats('scolalu01', 'LUIS.SCOLA')
Jonas.Valancuinas.All <- PlayerStats('valanjo01', 'JONAS.VALANCIUNAS')
Delon.Wright.All <- PlayerStats('wrighde01', 'DELON.WRIGHT')

Toronto.Tm <- rbind(Anthony.Bennett.All, Bismack.Biyombo.All, Bruno.Caboclo.All, 
                    DeMarre.Carroll.All, DeMar.DeRozan.All, James.Johnson.All, Cory.Joseph.All, 
                    Kyle.Lowry.All, Lucas.Nogueira.All, Patrick.Patterson.All, Norman.Powell.All, 
                    Terrance.Ross.All, Luis.Scola.All, Jonas.Valancuinas.All, Delon.Wright.All)

###############
###Utah Jazz###
###############

Trevor.Booker.All <- PlayerStats('booketr01', 'TREVOR.BOOKER')
Trey.Burke.All <- PlayerStats('burketr01', 'TREY.BURKE')
Alec.Burks.All <- PlayerStats('burksal01', 'ALEC.BURKS')
Derrick.Favors.All <- PlayerStats('favorde01', 'DERRICK.FAVORS')
Rudy.Gobert.All <- PlayerStats('goberru01', 'RUDY.GOBERT')
Gordon.Hayward.All <- PlayerStats('haywago01', 'GORDON.HAYWARD')
Rodney.Hood.All <- PlayerStats('hoodro01', 'RODNEY.HOOD')
Joe.Ingles.All <- PlayerStats('inglejo01', 'JOE.INGLES')
Chris.Johnson.All <- PlayerStats('johnsch04', 'CHRIS.JOHNSON')
Trey.Lyles.All <- PlayerStats('lylestr01', 'TREY.LYLES')
Elijah.Millsap.All <- PlayerStats('millsel01', 'ELIJAH.MILLSAP')
Raul.Neto.All <- PlayerStats('netora01', 'RAUL.NETO')
Tibor.Pleiss.All <- PlayerStats('pleisti01', 'TIBOR.PLEISS')
Jeff.Withey.All <- PlayerStats('witheje01', 'JEFF.WITHEY')

Utah.Tm <- rbind(Trevor.Booker.All, Trey.Burke.All, Alec.Burks.All,
                 Derrick.Favors.All, Rudy.Gobert.All, Gordon.Hayward.All, Rodney.Hood.All,
                 Joe.Ingles.All, Chris.Johnson.All, Trey.Lyles.All, Elijah.Millsap.All,
                 Raul.Neto.All, Tibor.Pleiss.All, Jeff.Withey.All)

########################
###Washington Wizards###
########################

#Alan.Anderson.All <- PlayerStats('anderal01', 'ALAN.ANDERSON')
Bradley.Beal.All <- PlayerStats('bealbr01', 'BRADLEY.BEAL')
DeJuan.Blair.All <- PlayerStats('blairde01', 'DEJUAN.BLAIR')
Jared.Dudley.All <- PlayerStats('dudleja01', 'JARED.DUDLEY')
Jarell.Eddie.All <- PlayerStats('eddieja01', 'JARELL.EDDIE')
Drew.Gooden.All <- PlayerStats('goodedr01', 'DREW.GOODEN')
Marcin.Gortat.All <- PlayerStats('gortama01', 'MARCIN.GORTAT')
Nene.Hilario.All <- PlayerStats('hilarne01', 'NENE.HILARIO')
Kris.Humphries.All <- PlayerStats('humphkr01', 'KRIS.HUMPHRIES')
Gary.Neal.All <- PlayerStats('nealga01', 'GARY.NEAL')
Kelly.Oubre.All <- PlayerStats('oubreke01', 'KELLY.OUBRE.JR')
Otto.Porter.All <- PlayerStats('porteot01', 'OTTO.PORTER')
Ramon.Sessions.All <- PlayerStats('sessira01', 'RAMON.SESSIONS')
Garrett.Temple.All <- PlayerStats('templga01', 'GARRETT.TEMPLE')
John.Wall.All <- PlayerStats('walljo01', 'JOHN.WALL')
#Martell.Webster.All <- PlayerStats('webstma02', 'MARTELL.WEBSTER')

Washington.Tm <- rbind(Bradley.Beal.All, DeJuan.Blair.All, Jared.Dudley.All, 
                       Jarell.Eddie.All, Drew.Gooden.All, Marcin.Gortat.All, Nene.Hilario.All, 
                       Kris.Humphries.All, Gary.Neal.All, Kelly.Oubre.All, Otto.Porter.All, 
                       Ramon.Sessions.All, Garrett.Temple.All, John.Wall.All)

##########################
##########################
###Final Team Dataframe###
##########################
##########################

Teams.All <- rbind(Atlanta.Tm, Boston.Tm, Brooklyn.Tm, Chicago.Tm, Charlotte.Tm,
                   Cleveland.Tm, Dallas.Tm, Denver.Tm, Detroit.Tm, Golden.State.Tm, Houston.Tm,
                   Indiana.Tm, LA.Clippers.Tm, LA.Lakers.Tm, Memphis.Tm, Miami.Tm, Milwaukee.Tm,
                   Minnesota.Tm, New.Orleans.Tm, New.York.Tm, Oklahoma.City.Tm, Orlando.Tm,
                   Philadelphia.Tm, Phoenix.Tm, Portland.Tm, Sacramento.Tm, San.Antonio.Tm,
                   Toronto.Tm, Utah.Tm, Washington.Tm)


write.csv(Teams.All, '../data/teams_all.csv')
write.csv(Defenses.All, 'r/data/defenses_all.csv')


