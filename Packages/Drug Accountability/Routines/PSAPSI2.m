PSAPSI2 ;BIR/LTL-IV Dispensing (All Drugs) ;7/23/97
 ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**3,15**; 10/24/97
 ;This routine gathers IV dispensing for all drugs in a pharmacy location.
 ;
 ;References to ^PSDRUG( are covered by IA #2095
 ;References to ^PS(50.8 are covered by IA #771
 ;References to ^PS(52.6 are covered by IA #270
 ;References to ^PS(52.7 are covered by IA #770
 ;
 K PSAQUIT D PSAWARN^PSAPSI I $D(PSAQUIT) K PSAQUIT Q
 N DIC,DIE,DINUM,D0,D1,DLAYGO,DR,DIR,DIRUT,DTOUT,DUOUT,PSAPG,PSALN,PSALOCN,PSAS,PSA,PSAOUT,PSADT,DA,PSADRUG,PSADRUGN,PSAQ,PSAIV,PSAW,X,X2,Y,ZTSK
LOOK D ^PSADA G:'$G(PSALOC) QUIT
 I '$O(^PSD(58.8,+PSALOC,1,0)) W !!,"There are no drugs in ",PSALOCN,!! G QUIT
 D NOW^%DTC S PSADT=X,X="T-6000" D ^%DT S PSADT(1)=Y,(PSAPG,PSAOUT,PSADRUG)=0
 S DIR(0)="D^"_PSADT(1)_":"_PSADT_":AEX",DIR("A")="How far back would you like to collect",DIR("B")="T-6000"  D ^DIR K DIR S (PSADT(2),PSAR)=Y,(PSADT(3),PSAR(1))=0 I Y<1 S PSAOUT=1 Q
 S (PSADT(22),PSADT(23),PSAIV)=0
 S DIR(0)="Y",DIR("A")="Would you like a report of daily dispensing totals",DIR("B")="Yes" D ^DIR K DIR S:$D(DIRUT) PSAOUT=1 G:$D(DIRUT) STOP
 I Y'=1 S PSA(5)=1,ZTIO="",ZTRTN="LUP^PSAPSI2",ZTDESC="DA drug disp",ZTSAVE("PSA*")="",ZTDTH=$H D ^%ZTLOAD,HOME^%ZIS S PSAOUT=1 G STOP
DEV K IO("Q") N %ZIS,IOP,POP S %ZIS="Q" I Y=1 W ! D ^%ZIS
 I $G(POP) W !,"NO DEVICE SELECTED OR ACTION TAKEN!" S PSAOUT=1 G QUIT
 I $D(IO("Q")) N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTDTH S ZTRTN="LUP^PSAPSI2",ZTDESC="Daily drug dispensing",ZTSAVE("PSA*")="" D ^%ZTLOAD,HOME^%ZIS S PSAOUT=1 G STOP
LUP F  S PSADRUG=$O(^PSD(58.8,+PSALOC,1,PSADRUG)) Q:'PSADRUG  D:$Y+5>$G(IOSL)&('$G(PSA(5))) HEADER G:$G(PSAOUT) STOP D:$S($P($G(^PSD(58.8,+PSALOC,1,+PSADRUG,0)),U,14):$P($G(^(0)),U,14)>DT,1:1)  D:$D(^TMP("PSA",$J,+PSADRUG)) TASK
 .Q:$P($G(^PSD(58.8,+PSALOC,1,+PSADRUG,6)),U,3)
 .S PSADRUGN=$P($G(^PSDRUG(+PSADRUG,0)),U),PSAIV=0
 .I '$G(PSA(5))&('$G(PSAPG)) W @IOF D HEADER
 .S PSADT(3)=0,PSA(7)=1
 .I '$O(^PS(52.6,"AC",+PSADRUG,0))&('$O(^PS(52.7,"AC",+PSADRUG,0)))&('$G(PSA(5))) Q
 .S PSADRUG(1)=$O(^PS(52.6,"AC",+PSADRUG,0))
 .S PSADRUG(2)=$O(^PS(52.7,"AC",+PSADRUG,0))
 .S PSAW=PSADT(3)
 .F  S PSAIV=$O(^PS(50.8,PSAIV)) Q:'PSAIV  F PSADT(4)=PSADT(2):0 S PSADT(4)=$O(^PS(50.8,+PSAIV,2,PSADT(4))) Q:'PSADT(4)  D  D:$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,"AC",52.7,+PSADRUG(2),0)) SOL
 ..Q:'$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,"AC",52.6,+PSADRUG(1),0))
 ..S PSADRUG(3)=$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,"AC",52.6,+PSADRUG(1),0))
 ..F  S PSAW=$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,+PSADRUG(3),3,PSAW)) Q:'PSAW  S PSAW(1)=PSAW D:$O(^PSD(58.8,"AB",PSAW,0))=PSALOC
 ...S PSAQ=$G(PSAQ)+$P($G(^PS(50.8,+PSAIV,2,+PSADT(4),2,+PSADRUG(3),3,PSAW,0)),U,2)-$P($G(^(0)),U,5)
 ..S:$G(PSAQ) ^TMP("PSA",$J,+PSADRUG,PSADT(4))=$G(^TMP("PSA",$J,+PSADRUG,PSADT(4)))+PSAQ S (PSAQ,PSAW)=0
 .Q:$G(PSA(5))
 .S PSADRUG(1)=$P($G(^PSDRUG(+PSADRUG,660)),U,6),PSADRUG(2)=$P($G(^(660)),U,8)
 .S X=PSADRUG(1),X2="3$" D COMMA^%DTC S PSADRUG(3)=X
 .S (PSA(4),PSA(6))=0 F  S PSA(4)=$O(^TMP("PSA",$J,+PSADRUG,PSA(4))) Q:'PSA(4)  D:$Y+4>IOSL HEADER Q:PSAOUT  S PSA(6)=PSA(6)+1,Y=PSA(4) X ^DD("DD") D
 ..W:$G(PSA(6))=1 !!,PSADRUGN W !!,Y
 ..S (X,PSADRUG(6))=$G(^TMP("PSA",$J,+PSADRUG,PSA(4))),X2=0
 ..S:$P($G(^PSD(58.8,+PSALOC,1,+PSADRUG,6)),U,4) X=X/$P($G(^(6)),U,4)
 ..D COMMA^%DTC W ?14,X,PSADRUG(2),?40,PSADRUG(3),"/",PSADRUG(2),?63
 ..S PSADRUG(4)=$G(PSADRUG(4))+X
 ..S X=X*PSADRUG(1),PSADRUG(5)=$G(PSADRUG(5))+X,X2="2$" D COMMA^%DTC W ?40,X
 .I PSA(6) W !,PSALN,!,PSA(6)," DAY TOTALS: " S X=$G(PSADRUG(4)),X2=0 D COMMA^%DTC W ?5,X,PSADRUG(2) S PSADRUG(4)=0 S X=$G(PSADRUG(5)),X2="2$" D COMMA^%DTC W ?63,X S PSADRUG(5)=0
 I 'PSADRUG&($G(PSA(5))) S PSAOUT=1
STOP W:$E($G(IOST),1,2)="P-" @IOF
 I $E($G(IOST))="C",'$G(PSAOUT) W ! S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu." D ^DIR K DIR
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" K IO("Q")
 K ^TMP("PSA",$J),PSA
QUIT Q
HEADER I $E(IOST,1,2)'="P-",$G(PSAPG) S DIR(0)="E" D ^DIR K DIR I Y<1 S PSAOUT=1 Q
 I $$S^%ZTLOAD W !!,"Task #",$G(ZTSK),", ",$G(ZTDESC)," was stopped by ",$P($G(^VA(200,+$G(DUZ),0)),U),"." S PSAOUT=1 Q
 W:$Y @IOF S $P(PSALN,"-",81)="",PSAPG=$G(PSAPG)+1 W !,?2,"DAILY DISPENSING TOTALS FOR ",$E($G(PSALOCN),1,30),?70,"PAGE: ",PSAPG,!,PSALN,!
 W "  DATE",?23,"TOTAL",?45,"$/DISP",?67,"TOTAL",!
 W "DISPENSED",?23,"DISP",?46,"UNIT",?68,"COST",!,PSALN
 Q
TASK S ZTIO="",ZTRTN="^PSAPSI1",ZTDTH=$H,ZTDESC="Dispensing totals",(ZTSAVE("^TMP(""PSA"",$J,+PSADRUG,"),ZTSAVE("PSA*"))="" D ^%ZTLOAD,HOME^%ZIS
 W:'$G(PSA(5)) !!,"Updating transaction file and dispensing totals." Q
SOL S PSAW=PSADT(3),PSADRUG(3)=$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,"AC",52.7,+PSADRUG(2),0))
 F  S PSAW=$O(^PS(50.8,+PSAIV,2,+PSADT(4),2,+PSADRUG(3),3,PSAW)) Q:'PSAW  S PSAW(1)=PSAW D:$O(^PSD(58.8,"AB",PSAW,0))=PSALOC
 .S PSAQ=$G(PSAQ)+$P($G(^PS(50.8,+PSAIV,2,+PSADT(4),2,+PSADRUG(3),3,PSAW,0)),U,2)-$P($G(^(0)),U,5)
 S:PSAQ ^TMP("PSA",$J,+PSADRUG,PSADT(4))=$G(^TMP("PSA",$J,+PSADRUG,PSADT(4)))+PSAQ S (PSAQ,PSAW)=0
 Q
