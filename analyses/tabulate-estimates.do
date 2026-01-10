assert_macros tabsavedir, strict

local y pfbs
runregs `y' buff100m_area_transport_faciliti, ///
    xlabel(Transport facilities (area) within 100m buffer) savepath($tabsavedir/pfbs-100m-transportfacilities-fragment.tex)

runregs `y' buff500m_area_transport_faciliti, ///
    xlabel(Transport facilities (area) within 500m buffer) savepath($tabsavedir/pfbs-500m-transportfacilities-fragment.tex)

runregs `y' buff1000m_area_transport_facilit, ///
    xlabel(Transport facilities (area) within 1000m buffer) savepath($tabsavedir/pfbs-1000m-transportfacilities-fragment.tex)

runregs `y' buff1500m_area_transport_facilit, ///
    xlabel(Transport facilities (area) within 1500m buffer) savepath($tabsavedir/pfbs-1500m-transportfacilities-fragment.tex)
