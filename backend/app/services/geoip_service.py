import subprocess


class GeoIPService:


    @staticmethod
    def lookup(ip):

        if not ip or ip == "-":
            return {
                "country":"-",
                "city":"-",
                "isp":"-"
            }


        try:

            result = subprocess.run(
                [
                    "curl",
                    "-s",
                    f"https://ipinfo.io/{ip}/json"
                ],
                capture_output=True,
                text=True,
                timeout=3
            )


            import json

            data=json.loads(result.stdout)


            return {

                "country":
                    data.get("country","-"),

                "city":
                    data.get("city","-"),

                "isp":
                    data.get("org","-")

            }


        except Exception:

            return {

                "country":"-",
                "city":"-",
                "isp":"-"

            }
