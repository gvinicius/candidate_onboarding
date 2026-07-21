module CandidateProfilesHelper
  def search_status_class(status)
    base = "inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium"
    case status.to_s
    when "active"   then "#{base} bg-green-50 text-green-700"
    when "passive"  then "#{base} bg-amber-50 text-amber-700"
    when "inactive" then "#{base} bg-slate-100 text-slate-600"
    else "#{base} bg-slate-100 text-slate-600"
    end
  end

  def cv_status_class(status)
    base = "inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium"
    case status.to_s
    when "completed"  then "#{base} bg-green-50 text-green-700"
    when "processing" then "#{base} bg-blue-50 text-blue-700"
    when "pending"    then "#{base} bg-slate-100 text-slate-500"
    when "failed"     then "#{base} bg-red-50 text-red-700"
    else "#{base} bg-slate-100 text-slate-500"
    end
  end
end
