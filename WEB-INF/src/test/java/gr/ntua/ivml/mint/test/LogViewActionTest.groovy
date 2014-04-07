package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.actions.Logview

def lv = new Logview()
lv.setDatasetId("1014")
println lv.getJson().toString(2)
