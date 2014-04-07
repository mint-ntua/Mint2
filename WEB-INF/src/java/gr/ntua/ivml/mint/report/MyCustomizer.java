package gr.ntua.ivml.mint.report;

import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import net.sf.jasperreports.engine.JRChart;
import net.sf.jasperreports.engine.JRChartCustomizer;

public class MyCustomizer implements JRChartCustomizer {
	
	

	  @Override
	  public void customize(JFreeChart chart, JRChart jasperChart) {
	    if(chart == null) return;
	    if(!(chart.getPlot() instanceof CategoryPlot)) return;
	    CategoryPlot categoryPlot = (CategoryPlot) chart.getPlot();
	    categoryPlot.getDomainAxis().setMaximumCategoryLabelLines(3);
//	    categoryPlot.getDomainAxis().setMaximumCategoryLabelWidthRatio(0);
	  }
	}

