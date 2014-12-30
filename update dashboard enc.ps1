# Generate bash script to clean up puppet etc.
write-output "puppet cert clean ${hostname}.${domain}" | out-file -encoding ascii "${p}.sh"
write-output "cd /usr/share/puppet-dashboard" | out-file -encoding ascii -append "${hostname}.${domain}.sh"
write-output "rake RAILS_ENV=production node:del name=${hostname}.${domain}" | out-file -encoding ascii -append "${hostname}.${domain}.sh"
write-output "rake RAILS_ENV=production node:add name=${hostname}.${domain} classes=${classes}" | out-file -encoding ascii -append "${hostname}.${domain}.sh"

plink -l root -pw olorin puppet.devops.local -m "${hostname}.${domain}.sh"