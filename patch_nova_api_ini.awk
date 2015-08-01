BEGIN { match_count = 0; FS = "="; }
{
   if (/\s*#/) { print;}
   else if (api_sec == 1) {
      if (/\[*\]/) {
         api_sec = 2;
         if (once == 0) {
            print "[filter:audit]"; 
            print "paste.filter_factory=keystonemiddleware.audit:filter_factory";
            print ""; print;
            once = 1;
         }
         else { api_sec = 2; print;}
      }
      else if (/keystone = / || /keystone_nolimit = /) {
         n = split($2, values, " ");
         values[n] = "audit " values[n];
         new_value = $1 "=";
         for (x = 1; x <= n; x++) {
            new_value = new_value " " values[x];
         }
         print new_value;
      }
      else {print;}
   }
   else if (/\[composite:openstack_compute_api_v[1-3]+\]/){
      api_sec = 1;
      print;
   }
   else { print; }
}
