using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(BowlingScoreTest.Startup))]
namespace BowlingScoreTest
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            //ConfigureAuth(app);
        }
    }
}
