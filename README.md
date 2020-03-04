# Holo_Spectrum
Holo Spectrum

need to run ncl eemd first to get both IMFs in AM and FM. For the example:
;
; the first part to get imfs_fm then calculate the upper evenlopement
; the second part to get imfs_am
;
;%1.set initial parameters
   Nnormal   = 5 ; %number of spline envelope normalization for AM
   vlength   = dSizes(1)
   vlength_1 = vlength -1
   upper     = vTmp ;; new((/dSizes(0),dSizes(1)/),typeof(vTmp))
   upper     = 0

  do ni = 0,dSizes(0)-1
     vimf = vTmp(ni,:)

  ;%2.find absolute values
    abs_vimf = abs(vimf)

  ;%3.find the spline envelope for AM,take those out-loop start
    do jj=0,Nnormal-1
        extvar=extrema(abs_vimf)
        spmaxTmp = extvar[0]
        spminTmp = extvar[1]
        flag     = extvar[2]
        id_len   = get1Dindex(spmaxTmp(:,0),vlength)
        spmax    = spmaxTmp(0:id_len,:)
        id_len   = get1Dindex(spminTmp(:,0),vlength_1)
        spmin    = spminTmp(0:id_len,:)
  ;printVarSummary(spmax)

       dd    = ispan(0,vlength_1,1)
       upper(ni,:) = ftcurv(spmax(:,0),spmax(:,1),dd) ;; (xi, yi, 0.1, xo)
  delete(spmax)
  delete(spmin)
  delete(extvar)
    end do
  end do
  copy_VarMeta(vTmp,upper)


;; eemd on upper to get AM
;; eemd
      goal = 12;
      ens = 1000;
      nos_wn = 0.01 ;; stringtoint(getenv("nos_wn")) / 100.  ;; 0.2 ;; 0.01;
  print(nos_wn)
      dims   = 1    ;; the time axial in upper is on number one !!! not zero
      opt    = True
      opt@S_number     = 4
      opt@num_siftings = 50
      opt@rng_seed     = 0

  ;; 1-D EEMD
    imfs_am = eemd(upper,goal,ens,nos_wn,opt,dims)
  printVarSummary(imfs_am)
  copy_VarMeta(upper(0,:),imfs_am(0,0,:))

;
; Then need to run Matlab script run_upper_v1_v2.m to get  normalized quadrature 
;
