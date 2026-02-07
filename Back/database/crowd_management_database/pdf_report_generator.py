# pdf_report_generator.py
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter, A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, PageBreak
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY
from io import BytesIO
from datetime import datetime
from typing import Dict, List
import logging

logger = logging.getLogger(__name__)

class PDFReportGenerator:
    def __init__(self):
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()
    
    def _setup_custom_styles(self):
        """Setup custom paragraph styles"""
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=24,
            textColor=colors.HexColor('#29624F'),
            spaceAfter=30,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))
        
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=16,
            textColor=colors.HexColor('#29624F'),
            spaceBefore=20,
            spaceAfter=12,
            fontName='Helvetica-Bold'
        ))
        
        self.styles.add(ParagraphStyle(
            name='SubsectionHeader',
            parent=self.styles['Heading3'],
            fontSize=14,
            textColor=colors.HexColor('#1C4336'),
            spaceBefore=12,
            spaceAfter=8,
            fontName='Helvetica-Bold'
        ))
        
        self.styles.add(ParagraphStyle(
            name='CustomBodyText',
            parent=self.styles['Normal'],
            fontSize=10,
            spaceAfter=6,
            alignment=TA_JUSTIFY
        ))

        
        self.styles.add(ParagraphStyle(
            name='TableHeader',
            parent=self.styles['Normal'],
            fontSize=10,
            textColor=colors.white,
            fontName='Helvetica-Bold',
            alignment=TA_CENTER
        ))
        
        self.styles.add(ParagraphStyle(
            name='TableText',
            parent=self.styles['Normal'],
            fontSize=9,
            alignment=TA_CENTER
        ))
    
    def generate_pdf(self, report_data: Dict) -> BytesIO:
        """Generate PDF report from report data"""
        buffer = BytesIO()
        doc = SimpleDocTemplate(buffer, pagesize=letter,
                               rightMargin=72, leftMargin=72,
                               topMargin=72, bottomMargin=72)
        
        story = []
        
        # Title Page
        story.extend(self._create_title_page(report_data))
        story.append(PageBreak())
        
        # Executive Summary
        story.extend(self._create_executive_summary(report_data))
        story.append(Spacer(1, 0.3*inch))
        
        # Daily Statistics
        story.extend(self._create_daily_statistics(report_data))
        story.append(PageBreak())
        
        # Zone Analysis
        story.extend(self._create_zone_analysis(report_data))
        story.append(Spacer(1, 0.3*inch))
        
        # Camera Analysis
        story.extend(self._create_camera_analysis(report_data))
        
        # Comparative Analysis (if multi-day)
        if report_data.get('comparative_analysis'):
            story.append(PageBreak())
            story.extend(self._create_comparative_analysis(report_data))
        
        # Insights & Recommendations
        story.append(PageBreak())
        story.extend(self._create_insights(report_data))
        
        doc.build(story)
        buffer.seek(0)
        return buffer
    
    def _create_title_page(self, report_data: Dict) -> List:
        """Create title page"""
        metadata = report_data.get('report_metadata', {})
        date_range = metadata.get('date_range', {})
        
        story = []
        story.append(Spacer(1, 2*inch))
        
        title = Paragraph("Crowd Management Report", self.styles['CustomTitle'])
        story.append(title)
        story.append(Spacer(1, 0.5*inch))
        
        report_type = metadata.get('report_type', 'daily').replace('_', ' ').title()
        subtitle = Paragraph(f"{report_type} Report", self.styles['SectionHeader'])
        story.append(subtitle)
        story.append(Spacer(1, 0.3*inch))
        
        date_info = [
            ['Report Period:', f"{date_range.get('start_date', 'N/A')} to {date_range.get('end_date', 'N/A')}"],
            ['Generated At:', metadata.get('generated_at', 'N/A')[:19].replace('T', ' ')],
            ['Total Cameras:', str(metadata.get('total_cameras', 0))],
            ['Total Zones:', '5'],
        ]
        
        title_table = Table(date_info, colWidths=[2*inch, 3*inch])
        title_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#29624F')),
            ('TEXTCOLOR', (0, 0), (0, -1), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 11),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('TOPPADDING', (0, 0), (-1, -1), 12),
            ('BACKGROUND', (1, 0), (1, -1), colors.HexColor('#F5F5F5')),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ]))
        story.append(title_table)
        
        return story
    
    def _create_executive_summary(self, report_data: Dict) -> List:
        """Create executive summary section"""
        story = []
        summary = report_data.get('executive_summary', {})
        
        story.append(Paragraph("Executive Summary", self.styles['SectionHeader']))
        
        summary_data = []
        
        total_people = summary.get('total_people_today', 0)
        total_capacity = summary.get('total_capacity', 0)
        overall_occupancy = summary.get('overall_occupancy_percentage', 0)
        
        summary_data.append(['Total People Count:', f"{total_people:,}"])
        summary_data.append(['Total Capacity:', f"{total_capacity:,}"])
        summary_data.append(['Overall Occupancy:', f"{overall_occupancy:.1f}%"])
        
        peak_hour = summary.get('peak_hour')
        if peak_hour:
            summary_data.append(['Peak Hour:', f"{peak_hour.get('time', 'N/A')} ({peak_hour.get('avg_percentage', 0):.1f}%)"])
        
        most_crowded = summary.get('most_crowded_zone')
        if most_crowded:
            zone_name = most_crowded.get('zone_name', '').replace('_', ' ').title()
            summary_data.append(['Most Crowded Zone:', f"{zone_name} ({most_crowded.get('avg_percentage', 0):.1f}%)"])
        
        least_crowded = summary.get('least_crowded_zone')
        if least_crowded:
            zone_name = least_crowded.get('zone_name', '').replace('_', ' ').title()
            summary_data.append(['Least Crowded Zone:', f"{zone_name} ({least_crowded.get('avg_percentage', 0):.1f}%)"])
        
        summary_table = Table(summary_data, colWidths=[2.5*inch, 3.5*inch])
        summary_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#29624F')),
            ('TEXTCOLOR', (0, 0), (0, -1), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 10),
            ('TOPPADDING', (0, 0), (-1, -1), 10),
            ('BACKGROUND', (1, 0), (1, -1), colors.HexColor('#F5F5F5')),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ]))
        story.append(summary_table)
        
        return story
    
    def _create_daily_statistics(self, report_data: Dict) -> List:
        """Create daily statistics section"""
        story = []
        daily_stats = report_data.get('daily_statistics', [])
        
        story.append(Paragraph("Daily Statistics", self.styles['SectionHeader']))
        
        for day_stat in daily_stats:
            date = day_stat.get('date', '')
            story.append(Paragraph(f"Date: {date}", self.styles['SubsectionHeader']))
            
            summary = day_stat.get('summary', {})
            summary_row = [
                ['Metric', 'Value'],
                ['Total People', f"{summary.get('total_people', 0):,}"],
                ['Average Occupancy %', f"{summary.get('avg_percentage', 0):.2f}%"],
                ['Max People', f"{summary.get('max_people', 0)}"],
                ['Max Occupancy %', f"{summary.get('max_percentage', 0):.2f}%"],
            ]
            
            summary_table = Table(summary_row, colWidths=[3*inch, 3*inch])
            summary_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
                ('TOPPADDING', (0, 0), (-1, -1), 8),
                ('BACKGROUND', (0, 1), (-1, -1), colors.white),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
            ]))
            story.append(summary_table)
            story.append(Spacer(1, 0.2*inch))
            
            hourly_breakdown = day_stat.get('hourly_breakdown', [])
            if hourly_breakdown:
                story.append(Paragraph("Hourly Breakdown", self.styles['SubsectionHeader']))
                
                hourly_data = [['Hour', 'Total People', 'Avg %', 'Max People']]
                for hour_data in hourly_breakdown[:14]:
                    hourly_data.append([
                        hour_data.get('hour_label', ''),
                        str(hour_data.get('total_people', 0)),
                        f"{hour_data.get('avg_percentage', 0):.2f}%",
                        str(hour_data.get('max_people', 0))
                    ])
                
                hourly_table = Table(hourly_data, colWidths=[1.5*inch, 1.5*inch, 1.5*inch, 1.5*inch])
                hourly_table.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
                    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                    ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                    ('FONTSIZE', (0, 0), (-1, -1), 8),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                    ('TOPPADDING', (0, 0), (-1, -1), 6),
                    ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                    ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
                ]))
                story.append(hourly_table)
                story.append(Spacer(1, 0.3*inch))
        
        return story
    
    def _create_zone_analysis(self, report_data: Dict) -> List:
        """Create zone analysis section"""
        story = []
        zones = report_data.get('zone_analysis', [])
        
        story.append(Paragraph("Zone Analysis", self.styles['SectionHeader']))
        
        for zone in zones:
            zone_name = zone.get('zone_name', '').replace('_', ' ').title()
            story.append(Paragraph(f"Zone: {zone_name}", self.styles['SubsectionHeader']))
            
            zone_data = [
                ['Metric', 'Value'],
                ['Total Cameras', str(zone.get('total_cameras', 0))],
                ['Total Capacity', f"{zone.get('total_capacity', 0):,}"],
                ['Max People', str(zone.get('max_people', 0))],
                ['Average Occupancy %', f"{zone.get('avg_percentage', 0):.2f}%"],
                ['Max Occupancy %', f"{zone.get('max_percentage', 0):.2f}%"],
            ]
            
            zone_table = Table(zone_data, colWidths=[3*inch, 3*inch])
            zone_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
                ('TOPPADDING', (0, 0), (-1, -1), 8),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
            ]))
            story.append(zone_table)
            
            camera_details = zone.get('camera_details', [])
            if camera_details:
                story.append(Spacer(1, 0.1*inch))
                story.append(Paragraph("Camera Details", self.styles['BodyText']))
                
                cam_data = [['Camera ID', 'Area', 'Capacity', 'Avg %', 'Max People']]
                for cam in camera_details:
                    cam_data.append([
                        str(cam.get('camera_id', '')),
                        cam.get('area_name', ''),
                        str(cam.get('capacity', 0)),
                        f"{cam.get('avg_percentage', 0):.2f}%",
                        str(cam.get('max_people', 0))
                    ])
                
                cam_table = Table(cam_data, colWidths=[1.2*inch, 1.5*inch, 1.2*inch, 1.2*inch, 1.2*inch])
                cam_table.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1C4336')),
                    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                    ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                    ('FONTSIZE', (0, 0), (-1, -1), 8),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                    ('TOPPADDING', (0, 0), (-1, -1), 6),
                    ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                    ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
                ]))
                story.append(cam_table)
            
            story.append(Spacer(1, 0.3*inch))
        
        return story
    
    def _create_camera_analysis(self, report_data: Dict) -> List:
        """Create camera analysis section"""
        story = []
        cameras = report_data.get('camera_analysis', [])
        
        story.append(Paragraph("Camera Analysis", self.styles['SectionHeader']))
        
        if cameras:
            cam_summary_data = [['Camera Name', 'Zone', 'Capacity', 'Avg %', 'Max People', 'Peak Hour']]
            for cam in cameras:
                cam_summary_data.append([
                    cam.get('camera_name', ''),
                    cam.get('zone_name', '').replace('_', ' ').title(),
                    str(cam.get('capacity', 0)),
                    f"{cam.get('avg_percentage', 0):.2f}%",
                    str(cam.get('max_people', 0)),
                    f"{cam.get('peak_hour', 'N/A')}:00" if cam.get('peak_hour') is not None else 'N/A'
                ])
            
            cam_summary_table = Table(cam_summary_data, colWidths=[2*inch, 1.5*inch, 1*inch, 1*inch, 1*inch, 1*inch])
            cam_summary_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 7),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
            ]))
            story.append(cam_summary_table)
            story.append(Spacer(1, 0.3*inch))
            
            for cam in cameras[:5]:
                cam_name = cam.get('camera_name', '')
                story.append(Paragraph(f"{cam_name}", self.styles['SubsectionHeader']))
                
                cam_stats = [
                    ['Metric', 'Value'],
                    ['Zone', cam.get('zone_name', '').replace('_', ' ').title()],
                    ['Area', cam.get('area_name', '')],
                    ['Capacity', str(cam.get('capacity', 0))],
                    ['Max People', str(cam.get('max_people', 0))],
                    ['Average Occupancy %', f"{cam.get('avg_percentage', 0):.2f}%"],
                    ['Max Occupancy %', f"{cam.get('max_percentage', 0):.2f}%"],
                ]
                
                crowding_dist = cam.get('crowding_level_distribution', {})
                if crowding_dist:
                    cam_stats.append(['Low Level Count', str(crowding_dist.get('Low', 0))])
                    cam_stats.append(['Moderate Level Count', str(crowding_dist.get('Moderate', 0))])
                    cam_stats.append(['Crowded Level Count', str(crowding_dist.get('Crowded', 0))])
                
                cam_table = Table(cam_stats, colWidths=[2.5*inch, 3.5*inch])
                cam_table.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1C4336')),
                    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                    ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                    ('FONTSIZE', (0, 0), (-1, -1), 9),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                    ('TOPPADDING', (0, 0), (-1, -1), 6),
                    ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                    ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
                ]))
                story.append(cam_table)
                story.append(Spacer(1, 0.2*inch))
        
        return story
    
    def _create_comparative_analysis(self, report_data: Dict) -> List:
        """Create comparative analysis section for multi-day reports"""
        story = []
        comp_analysis = report_data.get('comparative_analysis', {})
        
        story.append(Paragraph("Comparative Analysis", self.styles['SectionHeader']))
        
        day_comparison = comp_analysis.get('day_comparison', [])
        if day_comparison:
            comp_data = [['Date', 'Total People', 'Avg Occupancy %', 'Peak Hour']]
            for day in day_comparison:
                peak_hour = f"{day.get('peak_hour', 'N/A')}:00" if day.get('peak_hour') is not None else 'N/A'
                comp_data.append([
                    day.get('date', ''),
                    f"{day.get('total_people', 0):,}",
                    f"{day.get('avg_percentage', 0):.2f}%",
                    peak_hour
                ])
            
            comp_table = Table(comp_data, colWidths=[2*inch, 2*inch, 2*inch, 2*inch])
            comp_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
                ('TOPPADDING', (0, 0), (-1, -1), 8),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
            ]))
            story.append(comp_table)
            story.append(Spacer(1, 0.3*inch))
        
        trends = comp_analysis.get('trends', {})
        if trends:
            story.append(Paragraph("Trends", self.styles['SubsectionHeader']))
            trends_data = [
                ['Trend Type', 'Status'],
                ['People Trend', trends.get('people_trend', 'N/A').title()],
                ['Occupancy Trend', trends.get('occupancy_trend', 'N/A').title()],
                ['Peak Hour Stability', trends.get('peak_hour_stability', 'N/A').title()],
            ]
            
            trends_table = Table(trends_data, colWidths=[3*inch, 3*inch])
            trends_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1C4336')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
                ('TOPPADDING', (0, 0), (-1, -1), 8),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
            ]))
            story.append(trends_table)
        
        return story
    
    def _create_insights(self, report_data: Dict) -> List:
        """Create insights and recommendations section"""
        story = []
        insights = report_data.get('insights_and_recommendations', [])
        
        story.append(Paragraph("Insights & Recommendations", self.styles['SectionHeader']))
        
        if insights:
            for i, insight in enumerate(insights, 1):
                story.append(Paragraph(f"{i}. {insight}", self.styles['CustomBodyText']))
                story.append(Spacer(1, 0.1*inch))
        else:
            story.append(Paragraph("No specific insights available for this period.", self.styles['CustomBodyText']))
        
        return story
    
    def _create_data_quality(self, report_data: Dict) -> List:
        """Create data quality section"""
        story = []
        data_quality = report_data.get('data_quality', {})
        
        story.append(Paragraph("Data Quality Metrics", self.styles['SectionHeader']))
        
        quality_data = [
            ['Metric', 'Value'],
            ['Total Measurements', f"{data_quality.get('total_measurements', 0):,}"],
            ['Expected Measurements', f"{data_quality.get('expected_measurements', 0):,}"],
            ['Data Completeness', f"{data_quality.get('data_completeness', 0):.2f}%"],
            ['Anomalies Detected', str(data_quality.get('anomalies_detected', 0))],
        ]
        
        quality_table = Table(quality_data, colWidths=[3*inch, 3*inch])
        quality_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#29624F')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F5F5F5')]),
        ]))
        story.append(quality_table)
        
        return story
