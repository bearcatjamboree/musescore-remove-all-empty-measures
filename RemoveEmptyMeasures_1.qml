//===========================================================================
// Title: Remove All Empty Measures
// Version: 1.0.0
// Description: Plugin to remove all empty measures from a score
// 
// Copyright (C) 2023 Clint Box
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 3
//  as published by the Free Software Foundation and appearing in
//  the file LICENSE
//===========================================================================

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import MuseScore 3.0

MuseScore {
    menuPath: "Plugins.RemoveAllEmptyMeasures"
    description: "Plugin to remove all empty measures from a score"
    version: "1.0.0"
    id: 'removeAllEmptyMeasuresID'

    Component.onCompleted: {
        // Note: mscoreMajorVersion may need to be defined elsewhere or obtained from MuseScore.
        if (mscoreMajorVersion >= 4) {
            removeAllEmptyMeasuresID.title = "Remove All Empty Measures";
            removeAllEmptyMeasuresID.categoryCode = "tools";
        }
    }

    MessageDialog {
        id: messageDialog
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok
        modality: Qt.ApplicationModal
        title: "General usage error"
        text: "General usage error."
  		onAccepted: {
			//console.log("And of course you could only agree.")
			//Qt.quit()
		}
    }
    
	function showMessage(title, text)
	{
		messageDialog.title = title;	
		messageDialog.text = text;
		messageDialog.open();
	}
    
    onRun: {
        curScore.startCmd();
        removeEmptyMeasures();        
        curScore.endCmd();
        showMessage("Finished", "Done!");           
    }
    
    function removeEmptyMeasures() {
    
		var cursor = curScore.newCursor();
		cursor.rewind(Cursor.SCORE_START);

		var measure = curScore.firstMeasure;

		while (measure) {
			if (measureIsEmpty(measure))
				removeElement(measure);
			measure = measure.nextMeasure;
		}
        
    }

	function measureIsEmpty(measure) {

		var segment = measure.firstSegment;
					
		while (segment) {
			var element
			element = segment.elementAt(0)
			if (element && element.type == Element.CHORD) {
				return false;						
			}
			segment = segment.nextInMeasure;
        }
                
		return true;
	}
	
}
