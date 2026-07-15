import subprocess



class OcservService:



    @staticmethod
    def add_user(username,password):

        cmd=[
            "ocpasswd",
            "-c",
            "/etc/ocserv/ocpasswd",
            username
        ]


        process=subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )


        process.communicate(
            password+"\n"+password+"\n"
        )


        return process.returncode == 0



    @staticmethod
    def delete_user(username):

        cmd=[
            "ocpasswd",
            "-c",
            "/etc/ocserv/ocpasswd",
            "-d",
            username
        ]


        result=subprocess.run(
            cmd,
            capture_output=True
        )


        return result.returncode == 0
