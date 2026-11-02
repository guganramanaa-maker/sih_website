param()

function Create-SimplePdf {
    param(
        [string]$OutputPath,
        [string]$Title,
        [string[]]$Lines
    )

    $streamContent = "BT`n"
    $streamContent += "/F2 16 Tf`n"
    $streamContent += "50 740 Td`n"
    $streamContent += "($Title) Tj`n"
    $streamContent += "/F1 11 Tf`n"
    $streamContent += "0 -24 Td`n"

    foreach ($line in $Lines) {
        $escaped = $line.Replace('\', '\\').Replace('(', '\(').Replace(')', '\)')
        if ($escaped.StartsWith("###")) {
            $h = $escaped.Substring(3).Trim()
            $streamContent += "/F2 12 Tf`n"
            $streamContent += "0 -20 Td ($h) Tj`n"
            $streamContent += "/F1 10.5 Tf`n"
        } elseif ($escaped.Trim() -eq "") {
            $streamContent += "0 -12 Td () Tj`n"
        } else {
            $streamContent += "0 -15 Td ($escaped) Tj`n"
        }
    }
    $streamContent += "ET`n"

    $streamBytes = [System.Text.Encoding]::ASCII.GetBytes($streamContent)
    $streamLen = $streamBytes.Length

    $pdf = @"
%PDF-1.4
1 0 obj
<< /Type /Catalog /Pages 2 0 R >>
endobj
2 0 obj
<< /Type /Pages /Kids [3 0 R] /Count 1 >>
endobj
3 0 obj
<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> >>
endobj
4 0 obj
<< /Length $streamLen >>
stream
$streamContent
endstream
endobj
5 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>
endobj
6 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>
endobj
xref
0 7
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000244 00000 n 
0000000000 00000 n 
0000000000 00000 n 
trailer
<< /Size 7 /Root 1 0 R >>
startxref
"@

    # Calculate exact xref offsets
    $obj1 = "%PDF-1.4`n"
    $obj2 = $obj1 + "1 0 obj`n<< /Type /Catalog /Pages 2 0 R >>`nendobj`n"
    $obj3 = $obj2 + "2 0 obj`n<< /Type /Pages /Kids [3 0 R] /Count 1 >>`nendobj`n"
    $obj4 = $obj3 + "3 0 obj`n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> >>`nendobj`n"
    $obj5 = $obj4 + "4 0 obj`n<< /Length $streamLen >>`nstream`n$streamContent`nendstream`nendobj`n"
    $obj6 = $obj5 + "5 0 obj`n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>`nendobj`n"
    $obj7 = $obj6 + "6 0 obj`n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>`nendobj`n"

    $o1 = 9
    $o2 = $obj1.Length
    $o3 = $obj2.Length
    $o4 = $obj3.Length
    $o5 = $obj4.Length
    $o6 = $obj5.Length

    $xrefOffset = $obj7.Length

    $finalPdf = $obj7 + @"
xref
0 7
0000000000 65535 f 
$("{0:D10}" -f $o2) 00000 n 
$("{0:D10}" -f $o3) 00000 n 
$("{0:D10}" -f $o4) 00000 n 
$("{0:D10}" -f $o5) 00000 n 
$("{0:D10}" -f $o6) 00000 n 
$("{0:D10}" -f $xrefOffset) 00000 n 
trailer
<< /Size 7 /Root 1 0 R >>
startxref
$xrefOffset
%%EOF
"@

    [System.IO.File]::WriteAllBytes($OutputPath, [System.Text.Encoding]::ASCII.GetBytes($finalPdf))
    Write-Host "Generated $OutputPath"
}

# 1. Affiliation Certificate
Create-SimplePdf -OutputPath "assets\documents\1_Affiliation_Certificate_Anna_University.pdf" `
    -Title "ANNA UNIVERSITY CHENNAI - CERTIFICATE OF AFFILIATION" `
    -Lines @(
        "Ref No: AU/Affiliation/2026-27/SKCET-2718",
        "Date of Issue: 15-June-2026   |   Academic Year: 2026-2027",
        "",
        "### STATUTORY UNIVERSITY AFFILIATION ENDORSEMENT",
        "This is to certify that Sri Krishna College of Engineering and Technology (College Code: 2718),",
        "located at Kuniamuthur, Coimbatore - 641008, Tamil Nadu, is granted Continuation of Provisional",
        "and Permanent Affiliation under Anna University Chennai as prescribed in the Tamil Nadu State Acts.",
        "",
        "### APPROVED UNDERGRADUATE COURSES & INTAKE FOR 2026-2027:",
        "1. B.E. Computer Science and Engineering - 180 Seats (Permanent Affiliation)",
        "2. B.Tech Artificial Intelligence and Data Science - 120 Seats (New / Extension Approved)",
        "3. B.E. Electronics and Communication Engineering - 180 Seats (Permanent Affiliation)",
        "4. B.Tech Information Technology - 120 Seats (Permanent Affiliation)",
        "",
        "### REGULATORY COMPLIANCE STATUS:",
        "The institution fulfills all prescribed syllabus, exam conduct, curriculum, and faculty requirements",
        "stipulated under Anna University Regulations and Section 2.1 of the AICTE Approval Process Handbook.",
        "",
        "Signature: Prof. Dr. J. Kumar, Ph.D.   |   Registrar, Anna University Chennai",
        "Official Seal & Verification QR Code Hash: AU-CERT-2026-VERIFIED-OK"
    )

# 2A. AICTE Course Approval Letter - MISMATCHED / OUTDATED COPY (Triggers AI Rejection)
Create-SimplePdf -OutputPath "assets\documents\2_AICTE_Course_Approval_Letter_MISMATCHED.pdf" `
    -Title "AICTE NEW DELHI - [DEFICIENT / MISMATCHED DOCUMENT]" `
    -Lines @(
        "F.No. Southern/1-2718-TN/2023-2024/EOA-ARCHIVED",
        "Date: 10-May-2023   |   Academic Year: 2023-2024 (EXPIRED / OUTDATED)",
        "",
        "### STATUTORY DEFICIENCY AUDIT SUMMARY (AI OCR DETECTION):",
        "1. ACADEMIC YEAR MISMATCH: This order is for 2023-2024; portal application is for 2026-2027.",
        "2. INTAKE CAPACITY MISMATCH: Order approves 60 Seats; portal application requests 120 Seats.",
        "3. EXPIRED TENURE: Annual validity expired on 30-April-2024.",
        "",
        "### OUTDATED PROGRAM RECORD:",
        "Program: Engineering & Technology   |   Level: Under Graduate (B.Tech)",
        "Course: Artificial Intelligence and Data Science",
        "Approved Intake: 60 Seats Only (DEFICIENCY: Does NOT match 120 Seats applied for)",
        "",
        "### AI EVALUATION VERDICT: MISMATCH DETECTED - SUBMISSION BLOCKED",
        "The automated AI pre-scrutiny engine has flagged this document under APH Clause 3.2.",
        "Institution must resubmit the authenticated 2026-2027 EOA order approving 120 intake.",
        "",
        "Status: DEFICIENT COPY   |   Action Required: Click Resubmit & Attach 2026-2027 Order"
    )

# 2B. AICTE Course Approval Letter - VERIFIED / RECTIFIED COPY (Passes AI Validation)
Create-SimplePdf -OutputPath "assets\documents\2_AICTE_Course_Approval_Letter_VERIFIED.pdf" `
    -Title "ALL INDIA COUNCIL FOR TECHNICAL EDUCATION (NEW DELHI)" `
    -Lines @(
        "F.No. Southern/1-2718-TN/2026-2027/EOA-NEW-COURSE",
        "Date: 12-May-2026   |   Academic Year: 2026-2027 (ACTIVE / CURRENT)",
        "AICTE Approval Portal Reference: AICTE2026-001234",
        "",
        "### EXTENSION OF APPROVAL (EOA) & NEW COURSE INCLUSION ORDER",
        "To: The Principal / Director, Sri Krishna College of Engineering and Technology (AICTE ID: SKCET01),",
        "Kuniamuthur, Coimbatore, Tamil Nadu - 641008.",
        "",
        "In terms of provisions under AICTE Regulations 2024 and APH 2024-2027 norms, approval of the Council",
        "is hereby conveyed for the following program addition for Academic Year 2026-2027:",
        "",
        "Program: Engineering & Technology  |  Level: Under Graduate (B.Tech)",
        "Approved Course: Artificial Intelligence and Data Science",
        "Sanctioned Intake: 120 Seats  |  Duration: 4 Years  |  Affiliating Body: Anna University",
        "",
        "### AI OCR VERIFICATION AUDIT: 100% MATCHING",
        "- Academic Year matches portal application: 2026-2027 (MATCH)",
        "- Sanctioned intake matches portal application: 120 Seats (MATCH)",
        "- University Affiliation verified with Anna University Registry (MATCH)",
        "",
        "Signature: Member Secretary, AICTE New Delhi   |   Digitally Certified & Authenticated",
        "Official QR Verification Hash: AICTE-AUTH-2026-PASS-120-INTAKE"
    )

# 2C. Legacy duplicate copy for backward compatibility
Copy-Item "assets\documents\2_AICTE_Course_Approval_Letter_VERIFIED.pdf" "assets\documents\2_AICTE_Course_Approval_Letter.pdf" -Force

# 3. Infrastructure & Land Deed Certificate
Create-SimplePdf -OutputPath "assets\documents\3_Infrastructure_and_Land_Deed_Certificate.pdf" `
    -Title "INFRASTRUCTURE, LAND TITLE & SAFETY COMPLIANCE DOSSIER" `
    -Lines @(
        "Institution: Sri Krishna College of Engineering and Technology (Code: 2718)",
        "Survey Numbers: 142/1, 142/2, 143/1A, Kuniamuthur Village, Coimbatore District",
        "",
        "### LAND OWNERSHIP & LEASE VERIFICATION (APH SECTION 4.1):",
        "- Total Contiguous Land Area: 25.40 Acres (AICTE Rural Norm: Minimum 7.50 Acres - EXCEEDS NORM)",
        "- Registered Land Deed Number: Registered Deed No. 4821 at Sub-Registrar Office, Kuniamuthur",
        "- Tenure: Clear Ownership / Registered 30-Year Agreement in perpetuity for educational purpose",
        "",
        "### BUILT-UP CARPET AREA & ACCESSIBILITY CERTIFICATION:",
        "- Total Built-up Area: 42,500 sq.m. (Instructional: 21,500 sq.m., Admin: 7,200 sq.m., Amenities: 13,800 sq.m.)",
        "- Barrier-Free Campus: Certified with ramps, dedicated braille-enabled lifts, and disabled amenities",
        "- Structural Stability Certificate: Issued by Empanelled Structural Engineer Reg. No. TN-SE-4491",
        "- Fire Safety NOC: Issued by Tamil Nadu Fire and Rescue Services (NOC #TN-FRS-2026-981)",
        "",
        "Attestation: Chief Executive Officer & Tahsildar, Coimbatore South Division"
    )

# 4. Faculty Cadre and FSR Compliance
Create-SimplePdf -OutputPath "assets\documents\4_Faculty_Cadre_and_FSR_Compliance.pdf" `
    -Title "FACULTY CADRE RATIO & AADHAAR SEEDING VERIFICATION" `
    -Lines @(
        "Department: Artificial Intelligence and Data Science (AIDS) & Computer Science",
        "Academic Session: 2026-2027   |   AICTE Portal ID: SKCET01",
        "",
        "### CADRE RATIO & FACULTY-STUDENT RATIO (FSR) AUDIT:",
        "- AICTE Prescribed UG FSR Norm: 1:20   |   Institution Achieved FSR: 1:18.4 (COMPLIANT)",
        "- Cadre Distribution for AIDS: 1 Professor : 2 Associate Professors : 6 Assistant Professors",
        "- Total Department Faculty: 9 Full-time Regular Faculty Members",
        "",
        "### AADHAAR & PAN DATABASE SEEDING VERIFICATION:",
        "1. Dr. S. Radhika, Ph.D. - Professor & HOD (Aadhaar Verified: XXXX-XXXX-4812, AICTE ID: FAC-AI-01)",
        "2. Dr. M. Karthik, Ph.D. - Associate Professor (Aadhaar Verified: XXXX-XXXX-9104, AICTE ID: FAC-AI-02)",
        "3. Dr. P. Anitha, Ph.D. - Associate Professor (Aadhaar Verified: XXXX-XXXX-3321, AICTE ID: FAC-AI-03)",
        "4. 6 Assistant Professors with M.E/M.Tech First Class and 100% Aadhaar-PAN linkage verified.",
        "",
        "### PRINCIPAL / HEAD OF INSTITUTION QUALIFICATION:",
        "Dr. J. Janet, M.E., Ph.D. | 22 Years Academic Experience | 45 Research Papers in SCI Journals",
        "",
        "Certification: 100% compliant with Chapter VII of AICTE APH Regulations."
    )

Copy-Item "assets\documents\*.pdf" "." -Force
Write-Host "All statutory PDFs generated and mirrored to root directory!"

