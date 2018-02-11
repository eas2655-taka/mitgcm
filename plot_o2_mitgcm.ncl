; -------------------------------------------------------------------------------------------------
; NCL Script
; [plot_o2_mitgcm.ncl]
;
;   Plot dissolved oxygen distributions from MITgcm model data.
;
;  Yohei Takano, February 10th, 2017: Plotting the NetCDF file example.
;
; ------------------------------------------------------------------------------------------------- (L100)

begin

  ; ---------------------------------------------------------------------------
  ; 0. Options and load NetCDF file
  ; ---------------------------------------------------------------------------
  it =  0 ;--- first time step
  ik = 10 ;--- depth level at "11" (435m)
  ;--- Note that NCL index strats from "zero"

  wks_type = "x11"
  wks_name = "oxygen_MITgcm_CTL"

  f1 = addfile("o2_MITgcm_CTL_raw.nc","r")
  o2_mitgcm = f1->o2(it,ik,:,:) 
  ;--- dimensions o2(time, depth, lat, lon) 

  ; ---------------------------------------------------------------------------
  ; 1. Plottings
  ; ---------------------------------------------------------------------------
  wks = gsn_open_wks(wks_type,wks_name)
  plot = new(1,graphic)

  res                 = True
  res@gsnDraw         = False
  res@gsnFrame        = False

  res@cnFillOn        = True
  res@cnFillPalette   = "matlab_jet"

  res@cnLinesOn            = False
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       =   0
  res@cnMaxLevelValF       = 350.
  res@cnLevelSpacingF      =  10.

  res@cnLineLabelsOn  = False
  res@cnInfoLabelOn   = False

  res@lbLabelBarOn       = True
  res@lbLabelAngleF      =  45
  res@lbLabelFontHeightF =.022
  res@lbTitleOn          = True
  res@lbTitleString      = "Dissolved Oxygen [mmol/m~S~3~N~]"
  res@lbTitleFontHeightF = .022
  res@pmLabelBarOrthogonalPosF = .10

  res@tiMainString    = " "

  res@gsnStringFontHeightF = 0.025

  res@gsnCenterString = " "
  res@gsnLeftString   = "MITgcm-CTL"
  res@gsnRightString  = " "

  res@gsnAddCyclic    = True
  res@mpCenterLonF    = 200.
  res@mpProjection    = "Robinson"
  res@mpPerimOn       = False

  res@mpGridAndLimbOn = False
  res@mpLandFillColor = "peachpuff"

  plot(0) = gsn_csm_contour_map(wks,o2_mitgcm,res)
  draw(plot(0))
  frame(wks(0))

  ;-- exit
  ;--- Not necessary but sometimes you need this...
end
