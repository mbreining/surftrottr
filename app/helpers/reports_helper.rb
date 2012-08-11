module ReportsHelper

 def visibility(report)
   if report.is_good?
     return "highlite"
   elsif report.is_poor?
     return "hide"
   else
     return "neutral"
   end
 end
 
end


