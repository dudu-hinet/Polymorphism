Structure:
Table_View_Model1 & Table_View_Model2
		⎪				⎪
		⎪implement		⎪implement
		↓				↓
Table_View_Model	Table_View_Source
		↑				⎪
		⎪change			⎪assigned by View_Controller
		⎪				⎪
	View_Controller		⎪
		⎪				⎪
		⎪bind 			⎪
		⎪2 buttons		⎪
		↓				↓
		Table_View_Protocol
				↑
				⎪implement
				⎪
			Table_View