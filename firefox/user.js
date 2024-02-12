// Firefox user preferences
// store this file in the same location as prefs.js (~/.mozilla/firefox/<profileXXX>/)
//
// disable disk cache for SSD disks and specify RAM cache
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.capacity", 524288);
// prolong (disable) session restore interval from 15 seconds to 15,000
user_pref("browser.sessionstore.interval", 15000000);
