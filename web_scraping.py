import csv
from bs4 import BeautifulSoup
import requests
import json
import re

search_terms = [
    "Data Analyst",
    "Data Scientist",
    "Data Engineer",
    "Business Analyst",
]

csv_filename = "job_data.csv"
with open(csv_filename, mode='w', encoding='utf-8', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)
    headers = ["Title", "Company", "Date posted", "Valid until",
               "Education requirements", "Standardized Work Position",
               "Actual Position Name", "Seniority", "Technology",
               "Location", "Online Interview", "Accepts Students", "Work from Home"]
    csv_writer.writerow(headers)

    for term in search_terms:
        url = "https://www.helloworld.rs/oglasi-za-posao/?scope=full&q=" + term.replace(" ", "+")

        page = requests.get(url)
        soup = BeautifulSoup(page.text, "html.parser")

        job_tags = soup.find_all("a", class_="__ga4_job_title")

        links = []
        for element in job_tags:
            link = "https://helloworld.rs" + element["href"]
            links.append(link)

        for job_url in links:
            page = requests.get(job_url)
            soup = BeautifulSoup(page.text, "html.parser")

            scripts = soup.find_all("script", type="application/ld+json")

            for script in scripts:
                script_text = script.get_text()
                if "JobPosting" in script_text:
                    parsed = json.loads(script_text)

                    organization_name = parsed.get("hiringOrganization", {}).get("name", "")
                    educational_level = parsed.get("qualifications", {}).get("educationalLevel", "")

                    rec_interaction_script = soup.find("script", string=re.compile("global\.recInteraction"))
                    if rec_interaction_script:
                        rec_interaction_match = re.search(r'global\.recInteraction\s*=\s*\'(.*?)\';', rec_interaction_script.get_text())
                        if rec_interaction_match:
                            rec_interaction_data = rec_interaction_match.group(1)
                            rec_interaction_dict = json.loads(rec_interaction_data)
                            standardized_work_position = rec_interaction_dict["meta_data"].get("standardized_work_position", "")
                            actual_position_name = rec_interaction_dict["meta_data"].get("actual_position_name", "")
                            seniorities = rec_interaction_dict["meta_data"].get("seniorities", {})
                            technologies = rec_interaction_dict["meta_data"].get("technologies", {})
                            location = rec_interaction_dict["meta_data"].get("location", {})
                            online_interview = rec_interaction_dict["meta_data"].get("online_interview", False)
                            accepts_students = rec_interaction_dict["meta_data"].get("accepts_students", False)
                            work_from_home = rec_interaction_dict["meta_data"].get("work_from_home", False)

                    valid_through = parsed["validThrough"][:10]
                    seniorities_str = ", ".join(seniorities.keys()) if seniorities else "N/A"
                    technologies_str = ", ".join(technologies.keys()) if technologies else "N/A"
                    location_str = " | ".join(location.keys()) if location else "N/A"

                    csv_writer.writerow([parsed["title"], organization_name, parsed["datePosted"],
                                        valid_through, educational_level, standardized_work_position,
                                        actual_position_name, seniorities_str,
                                        technologies_str, location_str, online_interview,
                                        accepts_students, work_from_home])

print(f"CSV file '{csv_filename}' has been created.")