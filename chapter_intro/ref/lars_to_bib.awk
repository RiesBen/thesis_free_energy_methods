BEGIN{
#
# Read data about the articles from lars.tmp
#
  nref = 0
  inref = 0
#
  while ( (getline < larsfile )!=0 ) {
#
    if ( inref==0 ) {
      assumebook = 0
      assumechap = 0
      assumesftw = 0
      assumekill = 0
      assumepeco = 0
    }
#
    if ( $0 ~ "^CODE:" ) {
#
      nref++
      split ($0,l,"]")
      split (l[1],c,"[")
      code[nref] = c[2]
#
      if (inref!=0) {
        print "% CODE entry out of place"
        print "% line ",$0
        print "% code ",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^AUTH:" ) {
#
      auth[nref] = substr($0,7,length($0)-6)
#
      if (inref!=1) {
        print "% AUTH entry out of place"
        print "%",auth[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^DATE:" ) {
#
      date[nref] = substr($0,7,length($0)-6)
#
      if (inref!=2) {
        print "% DATE entry out of place"
        print "%",date[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^TITL:" ) {
#
      titl[nref] = substr($0,7,length($0)-6)
#
      if (assumebook || inref!=3) {
        print "% TITL entry out of place"
        print "%",titl[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^MATE:" ) {
#
      assumepeco = 1
      mate[nref] = substr($0,7,length($0)-6)
#
#      if (assumebook || inref!=3) {
#        print "% TITL entry out of place"
#        print "%",titl[nref]
#        print "% close to reference",code[nref]
#        exit
#      }
      inref++
    }
#
    if ( $0 ~ "^BKTI:" ) {
#
      bkti[nref] = substr($0,7,length($0)-6)
#
      if (inref==3) {
        assumebook = 1 
      }
#
      if (inref==4) {
        assumechap = 1
      }
#
      if ( !assumebook && !assumechap ) {
        print "% BKTI entry out of place"
        print "%",bkti[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^JRNL:" ) {
#
      jrnl[nref] = substr($0,7,length($0)-6)
#
      if (assumebook || assumechap || assumesftw || inref!=4) {
        print "% JRNL entry out of place"
        print "%",jrnl[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^WEBP:" ) {
#
      webp[nref] = substr($0,7,length($0)-6)
#
      if ( inref==4 ) {
        assumesftw = 1
      }
      if ( assumebook || assumechap || !assumesftw ) {
        print "% WEBP entry out of place"
        print "%",webp[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^VOLU:" ) {
#
      volu[nref] = substr($0,7,length($0)-6)
#
      err = 0
#
      if ( !(assumebook || assumechap) ) { err = 1 }
      if ( assumebook && inref!=4 ) { err = 1 } 
      if ( assumechap && inref!=5 ) { err = 1 } 
      if ( err ) {
        print "% VOLU entry out of place"
        print "%",volu[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^EDTN:" ) {
#
      edtn[nref] = substr($0,7,length($0)-6)
#
      err = 0
#
      if ( !(assumebook) ) { err = 1 }
      if ( assumebook && inref!=5 ) { err = 1 } 
      if ( err ) {
        print "% EDTN entry out of place"
        print "%",edtn[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^EDIT:" ) {
#
      edit[nref] = substr($0,7,length($0)-6)
#
      err = 0
#
      if ( !(assumechap) ) { err = 1 }
      if ( assumechap && inref!=6 ) { err = 1 } 
      if ( err ) {
        print "% EDIT entry out of place"
        print "%",edit[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^PUBL:" ) {
#
      publ[nref] = substr($0,7,length($0)-6)
#
      err = 0
#
      if ( !(assumebook || assumechap) ) { err = 1 }
      if ( assumebook && inref!=6 ) { err = 1 } 
      if ( assumechap && inref!=7 ) { err = 1 } 
      if ( err ) {
        print "% PUBL entry out of place"
        print "%",publ[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^PAGE:" ) {
#
      page[nref] = substr($0,7,length($0)-6)
#
      err = 0
#
      if ( !assumechap ) { err = 1 }
      if ( assumechap && inref!=8 ) { err = 1 } 
      if ( err ) {
        print "% PAGE entry out of place"
        print "%",page[nref]
        print "% close to reference",code[nref]
        exit
      }
      inref++
    }
#
    if ( $0 ~ "^TYPE:" ) {
#
      if ( inref==1 ) {
        assumekill = 1
      }

      type[nref] = substr($0,7,length($0)-6)
      err = 1
#
      if ( !assumekill && !assumebook && !assumechap && !assumesftw && !assumepeco && inref == 5 ) { err = 0 }      
      if ( assumekill && inref == 1) { err = 0 }
      if ( assumesftw && inref == 5) { err = 0 }
      if ( assumebook && inref == 7) { err = 0 }
      if ( assumechap && inref == 9) { err = 0 }
      if ( assumepeco && inref == 4) { err = 0 }
#
      if ( err ) {
        print "% TYPE entry out of place"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( assumekill && type[nref] != "KILL" ) {
        print "% TYPE entry incorrect for a killed entry (KILL)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( !assumekill && !assumebook && !assumechap && !assumesftw && !assumepeco && type[nref] != "PAPR" && type[nref] != "INPR" && type[nref] != "SUBM") {
        print "% TYPE entry incorrect for a paper (PAPR; INPR; SUBM)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( assumebook && type[nref] != "BOOK") {
        print "% TYPE entry incorrect for a book (BOOK)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( assumechap && type[nref] != "CHAP") {
        print "% TYPE entry incorrect for a chapter (CHAP)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( assumesftw && type[nref] != "SFTW") {
        print "% TYPE entry incorrect for a software (SFTW)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      if ( assumepeco && type[nref] != "PECO") {
        print "% TYPE entry incorrect for a personal communication (PECO)"
        print "%",type[nref]
        print "% close to reference",code[nref]
	exit
      }
#
      inref = 0
    }
#
  }
#
  print "% read",nref,"references from",larsfileori
#
# Generate a mapping from an integer that can be derived from the 
# reference name to the reference index in the reference-list arrays
#
  numer = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  numerl = length(numer)
  alphal = length(alpha)
#
  for ( i=1;i<=nref;i++) {
    x = code[i]
    i1 = index(alpha,substr(x,1,1))-1
    i2 = index(alpha,substr(x,2,1))-1
    i3 = index(numer,substr(x,3,1))-1
    i4 = index(numer,substr(x,4,1))-1
    i5 = index(numer,substr(x,6,1))-1
    if ( length(x)>6 ) {
      i6 = index(numer,substr(x,7,1))-1
    } else {
      i6 = i5
      i5 = 0
    }
    if ( length(x)>7 ) {
      i7 = index(numer,substr(x,8,1))-1
    } else {
      i7 = i6
      i6 = i5
      i5 = 0
    }
    if ( i1<0 || i2<0 || i3<0 || i4<0 || i5<0 || i6<0 || i7<0) {
      print "% illegal reference name ",x,"in reference list"
    }
    ii = (((((alphal*i1+i2)*numerl+i3)*numerl+i4)*numerl+i5)*numerl+i6)*numerl+i7
#    printf "% code %s %2d %2d %2d %2d %2d %2d %2d %d\n",x,i1,i2,i3,i4,i5,i6,i7,ii
#
    if (map[ii]!=0) {
      if ( x == "" ) {
        print "% duplicate reference code <void>"
      } else {
        print "% duplicate reference code",x
      }
    }
    map[ii] = i
#
  }
#
  nc = 0
  nct = 0
  linenn = ""
  leftover = ""
  err = 0
}
#
{ 
#
# get line (line)
#
  line = leftover substr($0,1,length($0))
# was a bug...
#  line = leftover substr($0,1,length($0)-1)
  leftover = ""
#  print "# ",line
#
# remove citations from the line and replace by
# "CITE<__>" (line -> linen)
#
  linen = ""
  n = split (line,l,"\\\\cite{")
  for ( nn=1; nn<n; nn++ ) {
    m = split (l[nn+1],ll,"}")
    if ( m==1 && nn!= n-1 ) {
      print "% mismatched brace"
      print "% line : ",line
      err = 1
      exit
    }
    if ( m==1 ) {
      linen = linen l[nn]
      leftover = "\\\\cite{" l[n]
      l[n] = ""
    } else {
      linen = linen l[nn] "CITE<"
#
#      nc++
#      cite[nc] = ll[1]
#
       mm=split(ll[1],lll,",")
       for ( mmm=1;mmm<=mm;mmm++ ) {
         nc++
         ct = lll[mmm]
# kill white spaces
         ctt = ""
         for (mmmm=1;mmmm<=length(ct);mmmm++) {
           cttt = substr(ct,mmmm,1)
           if (cttt != " ") {
             ctt = ctt cttt
           }
         }
         cite[nc] =ctt
       }
#
#      print ">",m,nc,cite[nc]
#
      linen = linen "__>"
      l[nn+1] = ll[2]
      for ( mm=3; mm<=m; mm++ ) {    
        l[nn+1] = l[nn+1] "}" ll[mm]
      }
    }
  }
  linen = linen l[n]
#  print ">", linen
#
# add at the rear of the current line
#
  linenn = linenn " " linen
#
#
#
}
END{
  if (err==1) {
    print "abnormal termination"
    exit
  }
#
#
  if (sss == "yes" ) {
# Maria, print in smaller font size and linespacing
   print "% PRINT REFLIST SMALLER TO SAVE PAPER"
   printf("{\\renewcommand{\\baselinestretch}{0.5}\\scriptsize\n")
# => do not forget to close the bracket below!
# 
   }
#
#
  print "% found",nc,"citations in source file"
#
  for (n=0;n<=nref;n++) {
    cited[n] = 0
  }
#
  nlist = 0
  nunk = 0
#
  for (n=1;n<=nc;n++) {
    x = cite[n]
#    print x

    i1 = index(alpha,substr(x,1,1))-1
    i2 = index(alpha,substr(x,2,1))-1
    i3 = index(numer,substr(x,3,1))-1
    i4 = index(numer,substr(x,4,1))-1
    i5 = index(numer,substr(x,6,1))-1
    if ( length(x)>6 ) {
      i6 = index(numer,substr(x,7,1))-1
    } else {
      i6 = i5
      i5 = 0
    }
    if ( length(x)>7 ) {
      i7 = index(numer,substr(x,8,1))-1
    } else {
      i7 = i6
      i6 = i5
      i5 = 0
    }
    if ( i1<0 || i2<0 || i3<0 || i4<0 || i5<0 || i6<0 || i7<0) {
      print "% illegal reference name",x,"quoted in source file"
    }
    iic = (((((alphal*i1+i2)*numerl+i3)*numerl+i4)*numerl+i5)*numerl+i6)*numerl+i7
#    printf "% code %s %2d %2d %2d %2d %2d %2d %2d %d\n",x,i1,i2,i3,i4,i5,i6,i7,
    iit = map[iic]

#    if ( iit==0 ) {

#    }

    ii = iit
#
    if (ii==0) {
      print "% unknown reference",x,"quoted in source file"
      nunk++
      code[nref+nunk] = x
      ii = nref+nunk
    }
#
    if ( cited[ii]==0 ) {
      nlist++
      refe[nlist]=ii
#      print x,code[ii]
    }
    cited[ii]++
  }
#    
  print "% found",nlist,"unique citations in source file"
  print "% found",nunk,"unknown citations in source file"
#
# now we can print the data
#
  for (n=1;n<=nlist;n++) {
    i = refe[n]
#
    iskill = ispapr = isbook = ischap = issftw = issubm = isinpr = ispeco = 0
    if ( type[i] == "KILL" ) { iskill = 1 }
    if ( type[i] == "PAPR" ) { ispapr = 1 }
    if ( type[i] == "BOOK" ) { isbook = 1 }
    if ( type[i] == "CHAP" ) { ischap = 1 }
    if ( type[i] == "SFTW" ) { issftw = 1 }
    if ( type[i] == "SUBM" ) { issubm = 1 }
    if ( type[i] == "INPR" ) { isinpr = 1 }
    if ( type[i] == "PECO" ) { ispeco = 1 }
#
    cde = code[i]
    aut = auth[i]
    dte = date[i]
    tit = titl[i]
    bkt = bkti[i]
# Maria, also make versions of tit and bkti, where there is no dot in the end 
    titnodot = substr(tit,1,length(tit)-1);
    bktnodot = substr(bkt,1,length(bkt)-1);
#
    jrn = jrnl[i]
    vol = volu[i]
    edn = edtn[i]
    pub = publ[i]
    edi = edit[i]
    pag = page[i]
    web = webp[i]
    typ = type[i]




#
# split author list
#
    naut = split(aut,autsep,",")/2
    for ( iaut=1; iaut<=naut; iaut++) {
      lstnm = autsep[2*iaut-1]
      fstnm = autsep[2*iaut]
#
# remove leading or trailing blanks
#
    if ( substr(lstnm,1,1) == " " ) {
      lstnm = substr(lstnm,2,length(lstnm)-1)
    }
    if ( substr(lstnm,length(lstnm),1) == " " ) {
        lstnm = substr(lstnm,1,length(lstnm)-1)
    }
#
    if ( substr(fstnm,1,1) == " " ) {
      fstnm = substr(fstnm,2,length(fstnm)-1)
    }
    if ( substr(fstnm,length(fstnm),1) == " " ) {
        fstnm = substr(fstnm,1,length(fstnm)-1)
    }
    autseplst[iaut] = lstnm
    autsepfst[iaut] = fstnm
# Maria make a version of fstnm without dots
     fstnm_nodot = fstnm
     gsub(/\./,"",fstnm_nodot)
     autsepfst_nodot[iaut] = fstnm_nodot
  }


   



#
# split editor list
#
    if ( ischap ) {
      nedi = split(edi,edisep,",")/2
      for ( iedi=1; iedi<=nedi; iedi++) {
        lstnm = edisep[2*iedi-1]
        fstnm = edisep[2*iedi]
#
# remove leading or trailing blanks
#
      if ( substr(lstnm,1,1) == " " ) {
        lstnm = substr(lstnm,2,length(lstnm)-1)
      }
      if ( substr(lstnm,length(lstnm),1) == " " ) {
          lstnm = substr(lstnm,1,length(lstnm)-1)
      }
#
      if ( substr(fstnm,1,1) == " " ) {
        fstnm = substr(fstnm,2,length(fstnm)-1)
      }
      if ( substr(fstnm,length(fstnm),1) == " " ) {
          fstnm = substr(fstnm,1,length(fstnm)-1)
      }
      ediseplst[iedi] = lstnm
      edisepfst[iedi] = fstnm

# Maria make a version of fstnm without dots
     fstnm_nodot = fstnm
     gsub(/\./,"",fstnm_nodot)
     edisepfst_nodot[iedi] = fstnm_nodot

    }
  }
#
# split journal record
#
# Maria: the submitted and in-press ones have to be here, too
    if (ispapr || issubm || isinpr ) {
      split (jrn,jrnsep,",")
#
      nwd = split (jrnsep[1],jrnsepsep," ")
      jrnti = ""
      for (iwd=1;iwd<nwd;iwd++) {
        jrnti = jrnti " " jrnsepsep[iwd]
      }

# Maria make a version of jrnti without dots
     jrnti_nodot = jrnti
     gsub(/\./,"",jrnti_nodot)



      jrnvo = jrnsepsep[nwd]
#
      split (jrnsep[2],jrnsepsep,"-")
      pagst = jrnsepsep[1]
      pagen = jrnsepsep[2]
#
# remove leading or trailing blanks
#
      if ( substr(jrnti,1,1) == " " ) {
        jrnti = substr(jrnti,2,length(jrnti)-1)
      }
      if ( substr(jrnti,length(jrnti),1) == " " ) {
        jrnti = substr(jrnti,1,length(jrnti)-1)
      }

      if ( substr(jrnvo,1,1) == " " ) {
        jrnvo = substr(jrnvo,2,length(jrnvo)-1)
      }
      if ( substr(jrnvo,length(jrnvo),1) == " " ) {
        jrnvo = substr(jrnvo,1,length(jrnvo)-1)
      }
#
      if ( substr(pagst,1,1) == " " ) {
        pagst = substr(pagst,2,length(pagst)-1)
      }
      if ( substr(pagst,length(pagst),1) == " " ) {
        pagst = substr(pagst,1,length(pagst)-1)
      }
#
      if ( substr(pagen,1,1) == " " ) {
        pagen = substr(pagen,2,length(pagen)-1)
      }
      if ( substr(pagen,length(pagen),1) == " " ) {
        pagen = substr(pagen,1,length(pagen)-1)
      }
    }
#





#
# reconstitute author list in various formats
# frm1: last name "," first name; separated by ","; last with "&" if multiple authors
#
  autfrm1 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm1 = autfrm1 lstnm ", " fstnm
    if ( iaut != naut ) {
      if ( iaut != naut-1 ) {
        autfrm1 = autfrm1 ", "
      } else {
        autfrm1 = autfrm1 " \\& "
      }
    }
  }

# Maria
# frm2: second name, first names;second name, first names
#
  autfrm2 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm2 = autfrm2 lstnm ", " fstnm
    if ( iaut != naut ) {
        autfrm2 = autfrm2 "; "
    }
  }

# Maria
# frm3: 
# first name second name, first name second name and first name second name
#
  autfrm3 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm3 = autfrm3 fstnm " " lstnm
    if ( iaut != naut ) {
      if ( iaut != naut-1 ) {
        autfrm3 = autfrm3 ", "
      } else {
        autfrm3 = autfrm3 " and "
      }
    }
  }



#
# frm4: last name "," first name, separated by ","; last with ", and" if multiple authors
#
  autfrm4 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm4 = autfrm4 lstnm ", " fstnm
    if ( iaut != naut ) {
      if ( iaut != naut-1 ) {
        autfrm4 = autfrm4 ", "
      } else {
        autfrm4 = autfrm4 ", and "
      }
    }
  }


# Maria
# frm5: 
# first name second name, first name second name, first name second name
#
  autfrm5 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm5 = autfrm5 fstnm " " lstnm
    if ( iaut != naut ) {
        autfrm5 = autfrm5 ", "
    }
  }



#
# frm6
# second name firstname_without_dots, second name firstname_without_dots
  autfrm6 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst_nodot[iaut]
    autfrm6 = autfrm6 lstnm " " fstnm
    if ( iaut != naut ) {
        autfrm6 = autfrm6 ", "
    }
  }



#
# frm7
# Initials with dots & last name 
  autfrm7 = ""
  for ( iaut=1; iaut<=naut; iaut++) {
    lstnm = autseplst[iaut]
    fstnm = autsepfst[iaut]
    autfrm7 = autfrm7 lstnm " " fstnm
    if ( iaut != naut ) {
        autfrm7 = autfrm7 ", "
    }
  }


#
# reconstitute editor list in various formats
# frm1: last name "," first name; separated by ","; last with "&" if multiple editors; added ", Ed(s).
#
  if ( ischap ) {
    edifrm1 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      edifrm1 = edifrm1 lstnm ", " fstnm
      if ( iedi != nedi ) {
        if ( iedi != nedi-1 ) {
          edifrm1 = edifrm1 ", "
        } else {
          edifrm1 = edifrm1 " \\& "
        }
      }
    }
    if (nedi==1) {
      edifrm1 = edifrm1 ", Ed."
    } else {
      edifrm1 = edifrm1 ", Eds."      
    }
  }


# Maria
# frm2: second name, first names;second name, first names
#
 if ( ischap ) {
    edifrm2 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      edifrm2 = edifrm2 lstnm ", " fstnm
      if ( iedi != nedi ) {
          edifrm2 = edifrm2 "; "
      }
    }
    if (nedi==1) {
      edifrm2 = edifrm2 ", Ed."
    } else {
      edifrm2 = edifrm2 ", Eds."
    }
  }

#
# Maria frm3
# first names second name, first names second name and first names second name
#
  if ( ischap ) {
    edifrm3 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      edifrm3 = edifrm3 fstnm " " lstnm
      if ( iedi != nedi ) {
        if ( iedi != nedi-1 ) {
          edifrm3 = edifrm3 ", "
        } else {
          edifrm3 = edifrm3 " and "
        }
      }
    }
    if (nedi==1) {
      edifrm3 = edifrm3 ", Ed."
    } else {
      edifrm3 = edifrm3 ", Eds."      
    }
  }



# frm4: last name "," first name, separated by ","; last with ", and" if multiple editors; added ", Ed(s).
#
  if ( ischap ) {
    edifrm4 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      edifrm4 = edifrm4 lstnm ", " fstnm
      if ( iedi != nedi ) {
        if ( iedi != nedi-1 ) {
          edifrm4 = edifrm4 ", "
        } else {
          edifrm4 = edifrm4 ", and "
        }
      }
    }
    if (nedi==1) {
      edifrm4 = edifrm4 ", Ed."
    } else {
      edifrm4 = edifrm4 ", Eds."      
    }
  }

#
# frm5: 
# first name second name, first name second name, first name second name
#

  if ( ischap ) {
    edifrm5 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      edifrm5 = edifrm5 fstnm " " lstnm
      if ( iedi != nedi ) {
          edifrm5 = edifrm5 ", "
     }
    }
    if (nedi==1) {
      edifrm5 = edifrm5 ", Ed."
    } else {
      edifrm5 = edifrm5 ", Eds."      
    }
  }


#
# frm6: 
# last name first name wo dot, last name first name wo dot
#

  if ( ischap ) {
    edifrm6 = ""
    for ( iedi=1; iedi<=nedi; iedi++) {
      lstnm = ediseplst[iedi]
      fstnm = edisepfst[iedi]
      fstnm_nodot = edisepfst_nodot[iedi]
      edifrm6 = edifrm6 lstnm " " fstnm_nodot
      if ( iedi != nedi ) {
          edifrm6 = edifrm6 ", "
      }
    }
    if (nedi==1) {
      edifrm6 = edifrm6 " (ed)"
    } else {
      edifrm6 = edifrm6 " (eds)"      
    }
  }







#
# Maria, if edifrm1,2,3 is ", Ed." or ", Eds.", i.e.,
# if there is no editor, do not report it!
#
     edipresentflag=1;
     if (edifrm1 == ", Ed." || edifrm1 == ", Eds." ){edifrm1 = "";edipresentflag=0;}
     if (edifrm2 == ", Ed." || edifrm2 == ", Eds." ){edifrm2 = "";edipresentflag=0;}
     if (edifrm3 == ", Ed." || edifrm3 == ", Eds." ){edifrm3 = "";edipresentflag=0;}
     if (edifrm4 == ", Ed." || edifrm4 == ", Eds." ){edifrm4 = "";edipresentflag=0;}
     if (edifrm5 == ", Ed." || edifrm5 == ", Eds." ){edifrm5 = "";edipresentflag=0;}
     if (edifrm6 == " (ed)" || edifrm6 == " (eds)" ){edifrm6 = "";edipresentflag=0;}




#
# reconstitute book title in various formats
# frm1: XXX
#
  if ( isbook ) {
    bktfrm1 = bkt
    bktfrm2 = bktnodot
    if ( vol != "-" && vol != "" ) {
      bktfrm1 = bktfrm1 " Volume " vol "."
      bktfrm2 = bktfrm2 " Volume " vol "."
    }
    if ( edn != "-" && edn != "" ) {
      bktfrm1 = bktfrm1 " Edition " edn "."
      bktfrm2 = bktfrm2 " Edition " edn "."
    }
  }
#
  if ( ischap ) {
    bktfrm1 = bkt
    bktfrm2 = bktnodot
    if ( vol != "-"  && vol != "" ) {
      bktfrm1 = bktfrm1 " Volume " vol "."
      bktfrm2 = bktfrm2 " Volume " vol "."
    }
  }



#
# reconstitute web page reference in various formats
# frm1: XXX
#
  if ( issftw ) {
    if ( web != "-" ) {
      webfrm1 = tit " Available at: {\\em " web "}"
    } else {
      webfrm1 = tit
    }
  }



#
#
#    printf "%% jrnti %s\n",jrnti
#    printf "%% jrnvo %s\n",jrnvo
#    printf "%% pagst %s\n",pagst
#    printf "%% pagen %s\n",pagen
#
#
    if ( i>nref ) {
      print "%",cde,"reference not found !"
    } else {
#
# now print the reference
#
      printf "\\bibitem{%s} ",cde
#
# default format: default with titles
#

#
#
#
      if ( ccc=="yes" ) {
#        printf "[%s,%s] ",cde,typ
        printf "[%s] ",cde
#        printf "[%s]",cde
      }
#
#
#
#
	# Maria, make a string of pagst which does not contain "/1" 
	# if we do not report page ranges ...
	pagstlasttwo=substr(pagst,length(pagst)-1,length(pagst));
        pagstshort=pagst;
	if (pagstlasttwo == "/1" ){
	pagstshort=substr(pagst,1,length(pagst)-2);
	}
#

# KILLED ENTRIES

	if (iskill) {
	    print "{\\bf ++++++++++++++++++++ WARNING: this reference is marked as a KILL in the lars file (i.e. the code was incorrect and the article has been renamed): check in lars.txt for the new name ++++++++++++++++++++}"
        }



#
#
      if ( format == "default_title" ) {
        if ( ispapr ) {
          printf "%s %s {\\em %s} {\\bf %s}, %s-%s (%s) \n",autfrm1,tit,jrnti,jrnvo,pagst,pagen,dte
         }
	if ( issubm ) {
	  printf "%s %s {\\em %s}, submitted (%s) \n",autfrm1,tit,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s %s {\\em %s}, in press (%s) \n",autfrm1,tit,jrnti,dte
	}
        if ( isbook ) {
          printf "%s %s %s (%s)\n",autfrm1,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s %s In: {\\em %s} %s %s, pp %s (%s)\n",autfrm1,tit,bktfrm1,edifrm1,pub,pag,dte
	}
	else{
          printf "%s %s In: {\\em %s}  %s, pp %s (%s)\n",autfrm1,tit,bktfrm1,pub,pag,dte
        }
        }
        if ( issftw ) {
          printf "%s %s (%s)\n",autfrm1,webfrm1,dte
        }
      }


##
#
# default format without titles
#
##
      if ( format == "default_no_title" ) {
        if ( ispapr ) {
          printf "%s {\\em %s} {\\bf %s}, %s-%s (%s) \n",autfrm1,jrnti,jrnvo,pagst,pagen,dte
         }
	if ( issubm ) {
	  printf "%s {\\em %s}, submitted (%s) \n",autfrm1,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s  {\\em %s}, in press (%s) \n",autfrm1,jrnti,dte
	}
        if ( isbook ) {
          printf "%s %s %s (%s)\n",autfrm1,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s %s In: {\\em %s} %s %s, pp %s (%s)\n",autfrm1,tit,bktfrm1,edifrm1,pub,pag,dte
	}
	else{
          printf "%s %s In: {\\em %s} %s, pp %s (%s)\n",autfrm1,tit,bktfrm1,pub,pag,dte
	}
        }
        if ( issftw ) {
          printf "%s %s (%s)\n",autfrm1,webfrm1,dte
        }
      }
#
# mol_simul_title
#
      if ( format == "mol_simul_title" ) {
        if ( ispapr ) {
          printf "%s, {\\em %s}, %s %s (%s), pp. %s-%s.\n",autfrm3,titnodot,jrnti,jrnvo,dte,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s, %s, submitted (%s).\n",autfrm3,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, %s, in press (%s).\n",autfrm3,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s}, %s (%s).\n",autfrm3,bktfrm2,pub,dte
        }
        if ( ischap ) {
          printf "%s %s In: {\\em %s}; %s; %s (%s); pp %s.\n",autfrm3,titnodot,bktfrm2,edifrm3,pub,dte,pag
        }
        if ( issftw ) {
          printf "%s, {\\em %s} (%s).\n",autfrm3,webfrm1,dte
        }
      }

#
# mol_simul_no_title
#
      if ( format == "mol_simul_no_title" ) {
        if ( ispapr ) {
          printf "%s, %s %s (%s), pp. %s-%s.\n",autfrm3,jrnti,jrnvo,dte,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s, %s, submitted (%s).\n",autfrm3,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, %s, in press (%s).\n",autfrm3,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s}, %s (%s).\n",autfrm3,bktfrm2,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s; %s (%s); pp %s.\n",autfrm3,titnodot,bktfrm2,edifrm3,pub,dte,pag
	}
	else{
          printf "%s %s In: {\\em %s}; %s (%s); pp %s.\n",autfrm3,titnodot,bktfrm2,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s, {\\em %s} (%s).\n",autfrm3,webfrm1,dte
        }
      }










#
#  j_phys_chem_no_title
#
# Maria

      if ( format == "j_phys_chem_no_title" ) {
        if ( ispapr ) {
          printf "%s {\\em %s} {\\bf %s}, {\\em %s}, %s-%s.\n",autfrm2,jrnti,dte,jrnvo,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s {\\em %s} {\\bf %s}, submitted. \n",autfrm2,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s {\\em %s} {\\bf %s}, in press. \n",autfrm2,jrnti,dte
	}
      if ( isbook ) {
          printf "%s {\\em %s}; %s, {\\bf %s}.\n",autfrm2,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s-%s. \n",autfrm2,tit,bktfrm1,edifrm1,pub,dte,pagst,pagen
	}
        else{
          printf "%s %s In: {\\em %s}; %s, {\\bf %s}; pp %s-%s. \n",autfrm2,tit,bktfrm1,pub,dte,pagst,pagen
	}
        }
        if ( issftw ) {
          printf "%s {\\em %s} {\\bf %s}.\n",autfrm2,webfrm1,dte
        }
      }




#
#  j_phys_chem_title
#
# Maria

      if ( format == "j_phys_chem_title" ) {
        if ( ispapr ) {
	    printf "%s %s. {\\em %s} {\\bf %s}, {\\em %s}, %s-%s.\n",autfrm2,titnodot,jrnti,dte,jrnvo,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s {\\em %s} {\\bf %s}, submitted. \n",autfrm2,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s {\\em %s} {\\bf %s}, in press. \n",autfrm2,jrnti,dte
	}
      if ( isbook ) {
          printf "%s {\\em %s}; %s, {\\bf %s}.\n",autfrm2,bktfrm1,pub,dte
        }
        if ( ischap ) {
        if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s-%s. \n",autfrm2,tit,bktfrm1,edifrm1,pub,dte,pagst,pagen
	}
	else{
          printf "%s %s In: {\\em %s}; %s, {\\bf %s}; pp %s-%s. \n",autfrm2,tit,bktfrm1,pub,dte,pagst,pagen
	}
        }
        if ( issftw ) {
          printf "%s {\\em %s} {\\bf %s}.\n",autfrm2,webfrm1,dte
        }
      }




#
# j_chem_phys_no_title
#
      if ( format == "j_chem_phys_no_title" ) {
        if ( ispapr ) {
          printf "%s, %s {\\bf %s}, %s (%s).\n",autfrm3,jrnti,jrnvo,pagstshort,dte
        } 
	if ( issubm ) {
	  printf "%s, %s, submitted (%s).\n",autfrm3,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, %s, in press (%s).\n",autfrm3,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s} (%s, %s).\n",autfrm3,bktfrm2,pub,dte
        }
        if ( ischap ) {
        if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s (%s, %s; pp %s).\n",autfrm3,titnodot,bktfrm2,edifrm3,pub,dte,pag
	}
	else{
          printf "%s %s In: {\\em %s} (%s, %s; pp %s).\n",autfrm3,titnodot,bktfrm2,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s, %s (%s).\n",autfrm3,webfrm1,dte
        }
      }

#
# j_chem_phys_title
#
      if ( format == "j_chem_phys_title" ) {
        if ( ispapr ) {
	    printf "%s, %s {\\bf %s}, %s (%s): %s.\n",autfrm3,jrnti,jrnvo,pagstshort,dte,titnodot
        } 
	if ( issubm ) {
	  printf "%s, %s, submitted (%s).\n",autfrm3,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, %s, in press (%s).\n",autfrm3,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s} (%s, %s).\n",autfrm3,bktfrm2,pub,dte
        }
        if ( ischap ) {
        if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s (%s, %s; pp %s).\n",autfrm3,titnodot,bktfrm2,edifrm3,pub,dte,pag
	}
	else{
          printf "%s %s In: {\\em %s} (%s, %s; pp %s).\n",autfrm3,titnodot,bktfrm2,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s, %s (%s).\n",autfrm3,webfrm1,dte
        }
      }









#
#  j_comput_chem_no_title
#
# Maria


      if ( format == "j_comput_chem_no_title" ) {
        if ( ispapr ) {
          printf "%s, {\\em %s} {\\bf %s}, {\\em %s}, %s.\n",autfrm5,jrnti,dte,jrnvo,pagst
        } 
	if ( issubm ) {
	  printf "%s, {\\em %s} {\\bf %s}, submitted.\n",autfrm5,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, {\\em %s} {\\bf %s}, in press.\n",autfrm5,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s}; %s, {\\bf %s}.\n",autfrm5,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s, %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s. \n",autfrm5,tit,bktfrm1,edifrm5,pub,dte,pag
	}
	else{
          printf "%s, %s In: {\\em %s}; %s, {\\bf %s}; pp %s. \n",autfrm5,tit,bktfrm1,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s, {\\em %s} {\\bf %s}.\n",autfrm5,webfrm1,dte
        }
      }




#
#  j_comput_chem_title
#
# Maria


      if ( format == "j_comput_chem_title" ) {
        if ( ispapr ) {
          printf "%s, {\\em %s} {\\bf %s}, {\\em %s}, %s: %s.\n",autfrm5,jrnti,dte,jrnvo,pagst,titnodot
        } 
	if ( issubm ) {
	  printf "%s, {\\em %s} {\\bf %s}, submitted.\n",autfrm5,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s, {\\em %s} {\\bf %s}, in press.\n",autfrm5,jrnti,dte
	}
      if ( isbook ) {
          printf "%s, {\\em %s}; %s, {\\bf %s}.\n",autfrm5,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s, %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s. \n",autfrm5,tit,bktfrm1,edifrm5,pub,dte,pag
	}
	else{
          printf "%s, %s In: {\\em %s}; %s, {\\bf %s}; pp %s. \n",autfrm5,tit,bktfrm1,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s, {\\em %s} {\\bf %s}.\n",autfrm5,webfrm1,dte
        }
      }


#  j_jacs_no_title
#
# Maria

      if ( format == "j_jacs_no_title" ) {
        if ( ispapr ) {
	    printf "%s {\\em %s} {\\bf %s}, {\\em %s}, %s-%s.\n",autfrm2,jrnti,dte,jrnvo,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s {\\em %s} {\\bf %s}, submitted. \n",autfrm2,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s {\\em %s} {\\bf %s}, in press. \n",autfrm2,jrnti,dte
	}
      if ( isbook ) {
          printf "%s {\\em %s}; %s, {\\bf %s}.\n",autfrm2,bktfrm1,pub,dte
        }
        if ( ischap ) {
	if (edipresentflag){
          printf "%s %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s. \n",autfrm2,tit,bktfrm1,edifrm1,pub,dte,pag
	}
        else{
	    printf "%s %s In: {\\em %s}; %s, {\\bf %s}; pp %s. \n",autfrm2,tit,bktfrm1,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s {\\em %s} {\\bf %s}.\n",autfrm2,webfrm1,dte
        }
      }




#
#  j_jacs_title
#
# Maria

      if ( format == "j_jacs_title" ) {
        if ( ispapr ) {
	    printf "%s {\\em %s} {\\bf %s}, {\\em %s}, %s-%s: %s.\n",autfrm2,jrnti,dte,jrnvo,pagst,pagen,titnodot
        } 
	if ( issubm ) {
	  printf "%s {\\em %s} {\\bf %s}, submitted. \n",autfrm2,jrnti,dte
	}
	if ( isinpr ) {
	  printf "%s {\\em %s} {\\bf %s}, in press. \n",autfrm2,jrnti,dte
	}
      if ( isbook ) {
          printf "%s {\\em %s}; %s, {\\bf %s}.\n",autfrm2,bktfrm1,pub,dte
        }
        if ( ischap ) {
        if (edipresentflag){
	    printf "%s %s In: {\\em %s}; %s; %s, {\\bf %s}; pp %s. \n",autfrm2,tit,bktfrm1,edifrm1,pub,dte,pag
	}
	else{
          printf "%s %s In: {\\em %s}; %s, {\\bf %s}; pp %s. \n",autfrm2,tit,bktfrm1,pub,dte,pag
	}
        }
        if ( issftw ) {
          printf "%s {\\em %s} {\\bf %s}.\n",autfrm2,webfrm1,dte
        }
      }


#
#  j_biochem
#
# Maria

      if ( format == "j_biochem" ) {
        if ( ispapr ) {
	    printf "%s (%s) %s {\\em %s} {\\em %s}, %s-%s.\n",autfrm6,dte,tit,jrnti,jrnvo,pagst,pagen
        } 
	if ( issubm ) {
	  printf "%s (%s) %s {\\em %s}, submitted. \n",autfrm4,dte,tit,jrnti
	}
	if ( isinpr ) {
	  printf "%s (%s) %s {\\em %s}, in press. \n",autfrm4,dte,tit,jrnti
	}
      if ( isbook ) {
          printf "%s (%s) {%s} %s.\n",autfrm4,dte,bktfrm1,pub
        }
        if ( ischap ) {
        if (edipresentflag){
	    printf "%s (%s) %s In: %s; %s; %s; pp %s. \n",autfrm4,dte,tit,bktfrm1,edifrm4,pub,pag
	}
	else{
          printf "%s (%s) %s In: %s; %s; pp %s. \n",autfrm4,dte,tit,bktfrm1,pub,pag
	}
        }
        if ( issftw ) {
          printf "%s (%s) %s.\n",autfrm4,dte,webfrm1
        }
      }


#
#  j_tca
#
# Maria

      if ( format == "j_tca" ) {
        if ( ispapr ) {
	    printf "%s (%s) %s  %s:%s\n",autfrm6,dte,jrnti_nodot,jrnvo,pagst
        } 
	if ( issubm ) {
	  printf "%s (%s) %s, submitted\n",autfrm6,dte,jrnti_nodot
	}
	if ( isinpr ) {
	  printf "%s (%s) %s, in press\n",autfrm6,dte,jrnti_nodot
	}
      if ( isbook ) {
          printf "%s (%s) %s %s\n",autfrm6,dte,bktfrm1,pub
        }
        if ( ischap ) {
        if (edipresentflag){
	    printf "%s (%s) In: %s %s %s, pp %s\n",autfrm6,dte,edifrm6,bktfrm1,pub,pag
	}
	else{
	    printf "%s (%s) In: %s %s, pp %s\n",autfrm6,dte,bktfrm1,pub,pag
	}
        }
        if ( issftw ) {
          printf "%s (%s) %s\n",autfrm6,dte,webfrm1
        }
      }


#
#  jctc
#
# NOAH

      if ( format == "jctc" ) {
          if ( ispapr ) {
              printf "%s %s \\textit{%s}  \\textbf{%s}, \\textit{%s}, %s\n",autfrm2,tit,jrnti,dte,jrnvo,pagst
          } 
          if ( issubm ) {
              printf "%s %s \\textit{%s} \\textbf{%s}, submitted\n",autfrm2,tit,jrnti,dte
          }
          if ( isinpr ) {
              printf "%s %s \\textit{%s} \\textbf{%s}, in press\n",autfrm2,tit,jrnti,dte
          }
          if ( isbook ) {
              if (edipresentflag){
                  #printf "%s In %s %s; %s, %s; %s.\n",autfrm2,bktfrm1,edifrm2,pub,dte,pag
                  printf "%s In %s; %s, %s; %s.\n",autfrm2,bktfrm1,pub,dte,pag
              }
              else {
                  printf "%s In %s; %s, %s; %s.\n",autfrm2,bktfrm1,pub,dte,pag
              }
          }
          if ( ischap ) {
              if (edipresentflag){
                  printf "%s In %s %s; %s, %s; %s.\n",autfrm2,bktfrm1,edifrm2,pub,dte,pag
              }
              else {
                  printf "%s In %s; %s, %s; %s.\n",autfrm2,bktfrm1,pub,dte,pag
              }
          }
          if ( issftw ) {
              printf "%s \\textit{%s} %s (accessed %s)\n",autfrm2,tit,web,dte
          }
}


#
#  JBSD (J. Biomol. Struct. Dyn)
#
# BRUNO

      if ( format == "j_jbsd_no_title" ) {
          if ( ispapr ) {
              printf "%s \\textit{%s} \\textit{%s}, %s-%s (%s).\n",autfrm3,jrnti,jrnvo,pagst,pagen,dte
          }
          if ( issubm ) {
              printf "%s %s \\textit{%s} \\textbf{%s}, submitted\n",autfrm3,tit,jrnti,dte
          }
          if ( isinpr ) {
              printf "%s %s \\textit{%s} \\textbf{%s}, in press\n",autfrm3,tit,jrnti,dte
          }
          if ( isbook ) {
              if (edipresentflag){
                  #printf "%s In %s %s; %s, %s; %s.\n",autfrm2,bktfrm1,edifrm2,pub,dte,pag
                  printf "%s In %s; %s, %s; %s.\n",autfrm3,bktfrm1,pub,dte,pag
              }
              else {
                  printf "%s In %s; %s, %s; %s.\n",autfrm3,bktfrm1,pub,dte,pag
              }
          }
          if ( ischap ) {
              if (edipresentflag){
                  printf "%s In %s %s; %s, %s; %s.\n",autfrm3,bktfrm1,edifrm2,pub,dte,pag
              }
              else {
                  printf "%s In %s; %s, %s; %s.\n",autfrm3,bktfrm1,pub,dte,pag
              }
          }
          if ( issftw ) {
              printf "%s \\textit{%s} %s (accessed %s)\n",autfrm3,tit,web,dte
          }
}







    }    
  }
  if (sss == "yes" ) {
# Maria, close bracket (from small printing; see above);
# and we need an empty line (otherwise the last ref will have wider linespacing);
   print "% CLOSE BRACKET FROM SMALL PRINTING"
   print "% AND INSERT A FREE LINE SO THAT THE NARROW LINESPACING STILL APPLIES TO THE LAST REF ..."
   printf("\n")
   printf("}\n")
   }
}





